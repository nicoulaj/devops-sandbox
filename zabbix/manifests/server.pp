class server($zabbix_version,
             $pg_version,
             $pg_password,
             $db_name,
             $db_user,
             $db_password) {

  include epel
  include stdlib
  include postgres

  package { "zabbix-server" :
    ensure  => present,
    require => Yumrepo[epel]
  }

  postgres::initdb { "database-init" :
    version  => "$pg_version",
    password => "$pg_password"
  }

  postgres::hba { "database-hba" :
    version  => "$pg_version",
    password => "$pg_password",
    allowedrules => [ "host all all 0.0.0.0/0 password" ],
    require => Postgres::Initdb["database-init"]
  }

  service { "postgresql" :
    name    => "postgresql-$pg_version",
    enable  => true,
    ensure  => running,
    require => Postgres::Hba["database-hba"]
  }

  postgres::createuser { "$db_user" :
    host     => "$::hostname",
    passwd   => "$db_password",
    password => "$pg_password",
    require  => Service["postgresql"]
  }

  postgres::createdb { "$db_name" :
    host     => "$::hostname",
    owner    => "$db_user",
    password => "$pg_password",
    require  => Postgres::Createuser["$db_user"]
  }

  exec{ "insert-schema":
    path        => $::path,
    cwd         => "/usr/share/doc/zabbix-server-pgsql-$zabbix_version/create/schema",
    environment => "PGPASSWORD=$db_password",
    user        => "$db_user",
    command     => "psql -d $db_name -a -f postgresql.sql",
    unless      => "psql -d $db_name -c 'SELECT tablename from pg_tables;' | grep slideshows",
    logoutput   => on_failure,
    require     => [ Package["zabbix-server"],
                     Postgres::Createdb["$db_name"] ]
  }

  exec{ "insert-data":
    path        => $::path,
    cwd         => "/usr/share/doc/zabbix-server-pgsql-$zabbix_version/create/data",
    environment => "PGPASSWORD=$db_password",
    user        => "$db_user",
    command     => "psql -d $db_name -a -f data.sql",
    unless      => "psql -d $db_name -c 'SELECT name from users;' | grep Zabbix",
    logoutput   => on_failure,
    require     => Exec["insert-schema"]
  }

  exec{ "insert-data-images":
    path        => $::path,
    cwd         => "/usr/share/doc/zabbix-server-pgsql-$zabbix_version/create/data",
    environment => "PGPASSWORD=$db_password",
    user        => "$db_user",
    command     => "psql -d $db_name -a -f images_pgsql.sql",
    unless      => "psql -d $db_name -c 'SELECT name from images;' | grep Hub",
    logoutput   => on_failure,
    require     => Exec["insert-schema"]
  }

  file_line { "/etc/zabbix/zabbix_server.conf":
    path      => "/etc/zabbix/zabbix_server.conf",
    line      => "DBPassword=$db_password",
    match     => ".*DBPassword=.*",
    require   => Package["zabbix-server"],
    subscribe => Package["zabbix-server"]
  }

  service { "zabbix-server" :
    enable    => true,
    ensure    => running,
    require   => [ Package["zabbix-server"],
                   File_line["/etc/zabbix/zabbix_server.conf"],
                   Service["postgresql"],
                   Exec["insert-data"] ],
    subscribe => [ Package["zabbix-server"],
                   File_line["/etc/zabbix/zabbix_server.conf"],
                   Service["postgresql"],
                   Exec["insert-data"] ]
  }
}

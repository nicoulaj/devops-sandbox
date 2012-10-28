class web($zabbix_server,
          $db_server,
          $db_name,
          $db_user,
          $db_password) {

  include epel

  package { "zabbix-web" :
    ensure  => present,
    require => Yumrepo[epel]
  }

  file { "/etc/php.d/zabbix.ini" :
    content => template("zabbix.php.ini.erb"),
    ensure  => present,
    require => Package["zabbix-web"]
  }

  file { "/etc/zabbix/web/zabbix.conf.php" :
    content => template("zabbix.conf.php.erb"),
    ensure  => present,
    require => Package["zabbix-web"]
  }

  service { "zabbix-web" :
    name      => "httpd",
    enable    => true,
    ensure    => running,
    require   => [ Package["zabbix-web"],
                   File["/etc/php.d/zabbix.ini"],
                   File["/etc/zabbix/web/zabbix.conf.php"] ],
    subscribe => [ Package["zabbix-web"],
                   File["/etc/php.d/zabbix.ini"],
                   File["/etc/zabbix/web/zabbix.conf.php"] ]
  }
}

node zabbix-server inherits default {

  class {'server':
    zabbix_version => '1.8.15',
    pg_version     => '9.0',
    pg_password    => 'postgres',
    db_name        => 'zabbix',
    db_user        => 'zabbix',
    db_password    => 'zabbix',
  }

  class {'web':
    zabbix_server => 'localhost',
    db_server     => 'localhost',
    db_name       => 'zabbix',
    db_user       => 'zabbix',
    db_password   => 'zabbix',
    require       => Class["server"]
  }

  class {'agent':
    zabbix_server => 'localhost'
  }
}

node /zabbix-node[0-9]+/ inherits default {
  class {'agent':
    zabbix_server => 'zabbix-server'
  }
}

node default {

  host { 'zabbix-server': ip => '192.168.60.10' }
  host { 'zabbix-node1':  ip => '192.168.60.11' }
  host { 'zabbix-node2':  ip => '192.168.60.12' }
  host { 'zabbix-node3':  ip => '192.168.60.13' }
  host { 'zabbix-node4':  ip => '192.168.60.14' }
  host { 'zabbix-node5':  ip => '192.168.60.15' }
  host { 'zabbix-node6':  ip => '192.168.60.16' }
  host { 'zabbix-node7':  ip => '192.168.60.17' }
  host { 'zabbix-node8':  ip => '192.168.60.18' }
  host { 'zabbix-node9':  ip => '192.168.60.19' }

  service { "iptables":
    enable => false,
    ensure => stopped,
  }

  file { '/etc/motd':
    content => template("motd.erb"),
  }
}

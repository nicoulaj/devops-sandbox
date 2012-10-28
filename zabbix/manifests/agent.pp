class agent ($zabbix_server) {

  include epel
  include stdlib

  package { "zabbix-agent" :
    ensure  => present,
    require => Yumrepo[epel]
  }

  file_line { "/etc/zabbix/zabbix_agentd.conf/Server":
    path      => "/etc/zabbix/zabbix_agentd.conf",
    line      => "Server=$zabbix_server",
    match     => "^Server=.*",
    require   => Package["zabbix-agent"],
    subscribe => Package["zabbix-agent"]
  }

  file_line { "/etc/zabbix/zabbix_agentd.conf/Hostname":
    path      => "/etc/zabbix/zabbix_agentd.conf",
    line      => "Hostname=$::hostname",
    match     => "^Hostname=.*",
    require   => Package["zabbix-agent"],
    subscribe => Package["zabbix-agent"]
  }

  service { "zabbix-agent" :
    enable    => true,
    ensure    => running,
    require   => [ Package["zabbix-agent"],
                   File_line["/etc/zabbix/zabbix_agentd.conf/Server"] ,
                   File_line["/etc/zabbix/zabbix_agentd.conf/Hostname"] ],
    subscribe => [ Package["zabbix-agent"],
                   File_line["/etc/zabbix/zabbix_agentd.conf/Server"],
                   File_line["/etc/zabbix/zabbix_agentd.conf/Hostname"]  ]
  }
}

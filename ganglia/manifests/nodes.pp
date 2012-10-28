node ganglia-server inherits default {

  include epel
  include ganglia

  class { "ganglia::client" :
    cluster                => 'unspecified',
    multicast_address      => '239.2.11.71',
    owner                  => 'unspecified',
    send_metadata_interval => 0,
    udp_port               => '8649',
    unicast_listen_port    => '8649',
    unicast_targets        => [],
    network_mode           => 'multicast'
  }

  class { "ganglia::server" :
    clusters => [{cluster_name => 'my_cluster',
                  cluster_hosts => [{address => 'localhost', port => '8649'}]}],
    gridname => ''
  }

  class { "ganglia::webserver" :
  }
}

node /ganglia-node[0-9]+/ inherits default {

  include epel
  include ganglia

  class { "ganglia::client" :
    cluster           => 'unspecified',
    multicast_address => '239.2.11.71',
    owner             => 'unspecified',
    send_metadata_interval => 0,
    udp_port => '8649',
    unicast_listen_port => '8649',
    unicast_targets => [],
    network_mode => 'multicast'
  }
}

node default {

  host { 'ganglia-server': ip => '192.168.60.10' }
  host { 'ganglia-node1':  ip => '192.168.60.11' }
  host { 'ganglia-node2':  ip => '192.168.60.12' }
  host { 'ganglia-node3':  ip => '192.168.60.13' }
  host { 'ganglia-node4':  ip => '192.168.60.14' }
  host { 'ganglia-node5':  ip => '192.168.60.15' }
  host { 'ganglia-node6':  ip => '192.168.60.16' }
  host { 'ganglia-node7':  ip => '192.168.60.17' }
  host { 'ganglia-node8':  ip => '192.168.60.18' }
  host { 'ganglia-node9':  ip => '192.168.60.19' }

  service { "iptables":
    enable => false,
    ensure => stopped,
  }

  file { '/etc/motd':
    content => template("motd.erb"),
  }
}

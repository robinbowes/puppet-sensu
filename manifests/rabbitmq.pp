# Class: sensu::rabbitmq
class sensu::rabbitmq {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0444'
  }

  Exec {
    path        => '/usr/bin:/usr/sbin:/bin',
    refreshonly => true
  }

  file { '/etc/apt/sources.list.d/rabbitmq.list':
    source => 'puppet:///modules/sensu/rabbitmq/rabbitmq.list';
  }

  exec { 'add rabbitmq aptkey':
    command   => 'curl http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -',
    subscribe => File['/etc/apt/sources.list.d/rabbitmq.list'],
    require   => File['/etc/apt/sources.list.d/rabbitmq.list'];
  }

  exec { 'apt get update':
    command   => 'apt-get update',
    subscribe => Exec['add rabbitmq aptkey'],
    require   => Exec['add rabbitmq aptkey'];
  }

  package {
    'rabbitmq-server':
      ensure  => installed,
      require => Exec['apt get update'];
    'rabbitmq-plugins-common':
      ensure  => installed,
      require => Package['rabbitmq-server'];
  }

  service { 'rabbitmq-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['rabbitmq-plugins-common'];
  }

  file { '/etc/rabbitmq/rabbitmq.config':
    source  => 'puppet:///modules/sensu/rabbitmq/rabbitmq.config',
    require => Service['rabbitmq-server'];
  }

  exec {
    'rabbitmq enable mgmt':
      command   => 'rabbitmq-plugins enable rabbitmq_management',
      unless    => 'rabbitmqctl list_vhosts name | grep sensu >/dev/null 2>&1';
    'rabbitmq add vhost':
      command   => 'rabbitmqctl add_vhost /sensu',
      subscribe => Exec['rabbitmq enable mgmt'],
      require   => Exec['rabbitmq enable mgmt'];
    'rabbitmq add user':
      command   => 'rabbitmqctl add_user sensu mypass',
      subscribe => Exec['rabbitmq add vhost'],
      require   => Exec['rabbitmq add vhost'];
    'rabbitmq set perms':
      command   => 'rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"',
      subscribe => Exec['rabbitmq set perms'],
      require   => Exec['rabbitmq set perms'];
  }

  file {
    '/etc/rabbitmq/ssl':
      ensure => directory,
      group  => 'rabbitmq',
      mode   => '0550';
    '/etc/rabbitmq/ssl/server_key.pem':
      source => 'puppet:///modules/sensu/rabbitmq/server_key.pem',
      group  => 'rabbitmq',
      mode   => '0440';
    '/etc/rabbitmq/ssl/server_cert.pem':
      source => 'puppet:///modules/sensu/rabbitmq/server_cert.pem',
      group  => 'rabbitmq';
    '/etc/rabbitmq/ssl/cacert.pem':
      source => 'puppet:///modules/sensu/rabbitmq/cacert.pem',
      group  => 'rabbitmq';
  }
}

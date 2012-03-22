# Class: sensu::redis
class sensu::redis {
  package { 'redis-server': ensure  => installed, }

  service { 'redis-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['redis-server'];
  }
}

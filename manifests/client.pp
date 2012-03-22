# Class: sensu::client
#
# This modules installs sensu
#
# Requires:
#   Ubuntu or Debian
#
# Sample usage:
#
#   Standard usage:
#     node 'foobar.acme.c.bitbit.net' {
#       include sensu::client
#     }
class sensu::client {
  include sensu

  $sensu_version = '0.9.4'

  package {
    'sensu':
      ensure   => $sensu_version,
      provider => gem,
      require  => Exec['install rubygems'];
    'sensu-plugin':
      ensure   => installed,
      provider => gem,
      require  => Exec['install rubygems'];
  }

  sensu::initscript { 'sensu-client': ensure => present; }

  service { 'sensu-client':
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    require    => Sensu::Initscript['sensu-client'];
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => File['/etc/sensu']
  }

  file {
    '/etc/sensu/conf.d/client.json':
      content => template('sensu/client/client.json.erb');
    '/etc/sensu/config.json':
      content => template('sensu/client/config.json.erb');
    '/etc/sensu/conf.d/basic_checks.json':
      content => template('sensu/client/basic_checks.json.erb');
  }

  package { 'nagios-plugins-standard': ensure => installed; }

  file { '/etc/logrotate.d/sensu-client':
    source => 'puppet:///modules/sensu/client/sensu-client.logrotate';
  }
}

# Class: sensu::server
#
# This modules installs sensu
#
# Requires:
#   Ubuntu
#
# Sample usage:
#
#   Standard usage:
#     node 'foobar.acme.c.bitbit.net' {
#       include sensu::server
#     }
class sensu::server {
  include sensu::client
  include sensu::rabbitmq
  include sensu::redis

  package {
    'sensu-dashboard':
      ensure   => '0.9.6',
      provider => gem,
      require  => Exec['install rubygems'];
    'mail':
      ensure   => installed,
      provider => gem;
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => File['/etc/sensu']
  }

  file {
    '/etc/sensu/conf.d/handlers.json':
      source => 'puppet:///modules/sensu/server/handlers.json';
    '/etc/sensu/conf.d/mailer.json':
      source => 'puppet:///modules/sensu/server/mailer.json';
    '/etc/sensu/handler/mailer.rb':
      source => 'puppet:///modules/sensu/server/handler.mailer.rb',
      mode   => '0555';
  }

  sensu::initscript {
    'sensu-api':       ensure => present;
    'sensu-dashboard': ensure => present;
    'sensu-server':    ensure => present;
  }

  file {
    '/etc/logrotate.d/sensu-api':       source => 'puppet:///modules/sensu/server/sensu-api.logrotate';
    '/etc/logrotate.d/sensu-dashboard': source => 'puppet:///modules/sensu/server/sensu-dashboard.logrotate';
    '/etc/logrotate.d/sensu-server':    source => 'puppet:///modules/sensu/server/sensu-server.logrotate';
  }
}

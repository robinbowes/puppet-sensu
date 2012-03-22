# Class: sensu
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
#       include sensu
#     }
class sensu {
  include ruby::rubygems

  class { 'sensu::user': }

  User  <| tag == 'sensu' |>
  Group <| tag == 'sensu' |>

  File {
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
    require => [ User['sensu'], Group['sensu'] ]
  }

  file {
    '/var/log/sensu':
      ensure => directory,
      mode   => '0755';
    '/var/run/sensu':
      ensure => directory,
      mode   => '0755';
    '/etc/sensu':         ensure => directory;
    '/etc/sensu/conf.d':  ensure => directory;
    '/etc/sensu/handler': ensure => directory;
    '/etc/sensu/ssl':     ensure => directory;
    '/etc/sensu/ssl/client_cert.pem':
      source => 'puppet:///modules/sensu/client/client_cert.pem',
      owner  => 'root';
    '/etc/sensu/ssl/client_key.pem':
      source => 'puppet:///modules/sensu/client/client_key.pem',
      owner  => 'root',
      mode   => '0440';
  }
}

# Class: sensu::user
class sensu::user (
  $sensu_homeroot = '/var/lib'
) {

  User {
    ensure     => present,
    managehome => true,
    shell      => '/bin/sh',
    system     => true
  }

  Group {
    ensure  => present,
    require => User['sensu']
  }

  @user {
    'sensu':
      comment => 'sensu system account',
      tag     => 'sensu',
      uid     => '3300',
      home    => "${sensu_homeroot}/sensu";
  }

  @group {
    'sensu':
      gid => '3300',
      tag => 'sensu';
  }
}

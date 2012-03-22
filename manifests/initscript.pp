# Define: sensu::initscript
#
# Simple wrapper to generate initscripts for sensu-services
define sensu::initscript ($ensure = undef) {
  case $ensure {
    'absent': {
      file { $name: ensure => $ensure; }
    }

    default: {
      file { $name:
        path    => "/etc/init.d/${name}",
        owner   => 'root',
        group   => 'root',
        mode    => '0555',
        content => template('sensu/initscript/sensu-init.erb');
      }
    }
  }
}

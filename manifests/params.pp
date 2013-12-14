# Class: horizon::params
#
# Defines all the variables used in the module.
#
class horizon::params {

  $package_name = $::osfamily ? {
    'Redhat' => 'openstack-horizon',
    default  => 'horizon-server',
  }

  $service_name = $::osfamily ? {
    'Redhat' => 'openstack-horizon-server',
    default  => 'horizon-server',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/horizon/horizon.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'horizon',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/horizon',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}

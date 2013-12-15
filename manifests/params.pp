# Class: horizon::params
#
# Defines all the variables used in the module.
#
class horizon::params {

  $package_name = $::osfamily ? {
    'Redhat'   => 'openstack-dashboard',
    'Debian'   => $::operatingsystem ? {
      'Debian' => 'openstack-dashboard-apache',
      'Ubuntu' => 'openstack-dashboard',
    }
  }

  $service_name = ''

  $config_file_path = $::osfamily ? {
    default  => '/etc/openstack-dashboard/local_settings.py',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/openstack-dashboard',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}

#
# = Class: horizon
#
# This class installs and manages horizon
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class horizon (

  $conf_hash                 = undef,
  $generic_service_hash      = undef,

  $package_name              = $horizon::params::package_name,
  $package_ensure            = 'present',

  $service_name              = $horizon::params::service_name,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = $horizon::params::config_file_path,
  $config_file_replace       = $horizon::params::config_file_replace,
  $config_file_require       = 'Package[horizon]',
  $config_file_notify        = 'class_default',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = undef,
  $config_file_owner         = $horizon::params::config_file_owner,
  $config_file_group         = $horizon::params::config_file_group,
  $config_file_mode          = $horizon::params::config_file_mode,

  $config_dir_path           = $horizon::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $tcp_port                  = undef,
  $udp_port                  = undef,

  ) inherits horizon::params {


  # Class variables validation and management

  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify  = $config_file_notify ? {
    'class_default' => 'Service[horizon]',
    ''              => undef,
    default         => $config_file_notify,
  }

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable
    $manage_service_ensure = $service_ensure
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources managed

  if $horizon::package_name {
    package { 'horizon':
      ensure   => $horizon::package_ensure,
      name     => $horizon::package_name,
    }
  }

  if $horizon::config_file_path {
    file { 'horizon.conf':
      ensure  => $horizon::config_file_ensure,
      path    => $horizon::config_file_path,
      mode    => $horizon::config_file_mode,
      owner   => $horizon::config_file_owner,
      group   => $horizon::config_file_group,
      source  => $horizon::config_file_source,
      content => $horizon::manage_config_file_content,
      notify  => $horizon::manage_config_file_notify,
      require => $horizon::config_file_require,
    }
  }

  if $horizon::config_dir_source {
    file { 'horizon.dir':
      ensure  => $horizon::config_dir_ensure,
      path    => $horizon::config_dir_path,
      source  => $horizon::config_dir_source,
      recurse => $horizon::config_dir_recurse,
      purge   => $horizon::config_dir_purge,
      force   => $horizon::config_dir_purge,
      notify  => $horizon::manage_config_file_notify,
      require => $horizon::config_file_require,
    }
  }

  if $horizon::service_name {
    service { 'horizon':
      ensure     => $horizon::manage_service_ensure,
      name       => $horizon::service_name,
      enable     => $horizon::manage_service_enable,
    }
  }


  # Extra classes
  if $conf_hash {
    create_resources('horizon::conf', $conf_hash)
  }

  if $generic_service_hash {
    create_resources('horizon::generic_service', $generic_service_hash)
  }


  if $horizon::dependency_class {
    include $horizon::dependency_class
  }

  if $horizon::my_class {
    include $horizon::my_class
  }

  if $horizon::monitor_class {
    class { $horizon::monitor_class:
      options_hash => $horizon::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $horizon::firewall_class {
    class { $horizon::firewall_class:
      options_hash => $horizon::firewall_options_hash,
      scope_hash   => {},
    }
  }

}


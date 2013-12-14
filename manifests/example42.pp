# = Class: horizon::example42
#
# Example42 puppi additions. To add them set:
#   my_class => 'horizon::example42'
#
class horizon::example42 {

  puppi::info::module { 'horizon':
    packagename => $horizon::package_name,
    servicename => $horizon::service_name,
    processname => 'horizon',
    configfile  => $horizon::config_file_path,
    configdir   => $horizon::config_dir_path,
    pidfile     => '/var/run/horizon.pid',
    datadir     => '',
    logdir      => '/var/log/horizon',
    protocol    => 'tcp',
    port        => '5000',
    description => 'What Puppet knows about horizon' ,
    # run         => 'horizon -V###',
  }

  puppi::log { 'horizon':
    description => 'Logs of horizon',
    log         => [ '/var/log/horizon/horizon.log' , '/var/log/horizon/horizon-manage.log' ],
  }

}


class anthill_game_controller (

  String $default_version                       = $anthill::default_version,

  Enum['present', 'absent'] $ensure             = 'present',
  String $service_name                          = $anthill_game_controller::params::service_name,
  String $server_name                           = $anthill_game_controller::params::server_name,
  String $package_name                          = $anthill_game_controller::params::package_name,
  String $package_directory                     = $anthill_game_controller::params::package_directory,

  String $repository_remote_url                 = $anthill_game_controller::params::repository_remote_url,
  Optional[String] $private_ssh_key             = undef,

  String $sock_directory                        = $anthill_game_controller::params::sock_directory,
  String $binaries_directory                    = $anthill_game_controller::params::binaries_directory,
  String $logs_directory                        = $anthill_game_controller::params::logs_directory,
  Integer $logs_keep_time                       = $anthill_game_controller::params::logs_keep_time,
  Integer $ports_pool_from                      = $anthill_game_controller::params::ports_pool_from,
  Integer $ports_pool_to                        = $anthill_game_controller::params::ports_pool_to,
  String $gs_host                               = $anthill_game_controller::params::gs_host,

  String $nginx_max_body_size                   = $anthill_game_controller::params::nginx_max_body_size,

  String $token_cache_location                  = $anthill_game_controller::params::token_cache_location,
  Integer $token_cache_db                       = $anthill_game_controller::params::token_cache_db,
  Integer $token_cache_max_connections          = $anthill_game_controller::params::token_cache_max_connections,

  Boolean $enable_monitoring                    = $anthill_game_controller::params::enable_monitoring,
  String $monitoring_location                   = $anthill_game_controller::params::monitoring_location,

  Boolean $debug                                = $anthill::debug,

  String $internal_broker_location              = $anthill_game_controller::params::internal_broker_location,
  String $pubsub_location                       = $anthill_game_controller::params::pubsub_location,

  Optional[String] $discovery_service           = undef,
  Optional[String] $host                        = undef,
  Optional[String] $domain                      = undef,
  Optional[String] $external_domain_name        = undef,
  Optional[String] $internal_domain_name        = undef,

  Optional[Array[String]] $internal_restrict    = undef,
  Optional[Integer] $internal_max_connections   = undef,
  Optional[String] $auth_key_public             = undef,
  Optional[Array[String]] $whitelist            = undef

) inherits anthill_game_controller::params {

  file { $binaries_directory:
    ensure => $ensure ? {default => 'directory', 'absent' => 'absent' },
    force  => true,
    owner  => $anthill::applications_user,
    group  => $anthill::applications_group,
    mode   => '0760'
  }

  file { $logs_directory:
    ensure => $ensure ? {default => 'directory', 'absent' => 'absent' },
    force  => true,
    owner  => $anthill::applications_user,
    group  => $anthill::applications_group,
    mode   => '0760'
  }

  require anthill::common

  anthill::service { $service_name:
    package_directory => $package_directory,
    default_version => $default_version,
    repository_remote_url => $repository_remote_url,
    private_ssh_key => $private_ssh_key,
    service_name => $service_name,
    ensure => $ensure,
    domain => $domain,
    external_domain_name => $external_domain_name,
    internal_domain_name => $internal_domain_name,
    internal_broker_location => $internal_broker_location,
    whitelist => $whitelist,

    export_discovery_entry => false,

    nginx_max_body_size => $nginx_max_body_size
  }


}

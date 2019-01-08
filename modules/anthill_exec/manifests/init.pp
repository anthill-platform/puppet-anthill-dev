
class anthill_exec (

  String $default_version                       = $anthill::default_version,

  Enum['present', 'absent'] $ensure             = 'present',
  String $service_name                          = $anthill_exec::params::service_name,
  String $server_name                           = $anthill_exec::params::server_name,
  String $package_name                          = $anthill_exec::params::package_name,
  String $package_directory                     = $anthill_exec::params::package_directory,

  String $repository_remote_url                 = $anthill_exec::params::repository_remote_url,
  Optional[String] $private_ssh_key             = undef,

  String $db_location                           = $anthill_exec::params::db_location,
  Optional[Boolean] $manage_db                  = true,
  String $db_name                               = $anthill_exec::params::db_name,

  String $token_cache_location                  = $anthill_exec::params::token_cache_location,
  Integer $token_cache_db                       = $anthill_exec::params::token_cache_db,
  Integer $token_cache_max_connections          = $anthill_exec::params::token_cache_max_connections,

  String $cache_location                        = $anthill_exec::params::cache_location,
  Integer $cache_db                             = $anthill_exec::params::cache_db,
  Integer $cache_max_connections                = $anthill_exec::params::cache_max_connections,

  Boolean $enable_monitoring                    = $anthill_exec::params::enable_monitoring,
  String $monitoring_location                   = $anthill_exec::params::monitoring_location,

  Boolean $debug                                = $anthill::debug,

  String $internal_broker_location              = $anthill_exec::params::internal_broker_location,
  String $pubsub_location                       = $anthill_exec::params::pubsub_location,

  String $js_source_path                        = $anthill_exec::params::js_source_path,
  Integer $js_call_timeout                      = $anthill_exec::params::js_call_timeout,

  Optional[String] $discovery_service           = undef,
  Optional[String] $host                        = undef,
  Optional[String] $domain                      = undef,
  Optional[String] $external_domain_name        = undef,
  Optional[String] $internal_domain_name        = undef,

  Optional[Array[String]] $internal_restrict    = undef,
  Optional[Integer] $internal_max_connections   = undef,
  Optional[String] $auth_key_public             = undef,
  Optional[Array[String]] $whitelist            = undef

) inherits anthill_exec::params {

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
    whitelist => $whitelist
  }

  if ($manage_db)
  {
    @@mysql_database { $db_name:
      ensure => 'present',
      charset => 'utf8',
      tag => [ $db_location, "env-${environment}" ]
    }
  }

}

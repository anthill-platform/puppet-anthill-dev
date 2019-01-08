
class anthill_profile (

  String $default_version                       = $anthill::default_version,

  Enum['present', 'absent'] $ensure             = 'present',
  String $service_name                          = $anthill_profile::params::service_name,
  String $server_name                           = $anthill_profile::params::server_name,
  String $package_name                          = $anthill_profile::params::package_name,
  String $package_directory                     = $anthill_profile::params::package_directory,

  String $repository_remote_url                 = $anthill_profile::params::repository_remote_url,
  Optional[String] $private_ssh_key             = undef,

  String $db_location                           = $anthill_profile::params::db_location,
  Optional[Boolean] $manage_db                  = true,
  String $db_name                               = $anthill_profile::params::db_name,

  String $token_cache_location                  = $anthill_profile::params::token_cache_location,
  Integer $token_cache_db                       = $anthill_profile::params::token_cache_db,
  Integer $token_cache_max_connections          = $anthill_profile::params::token_cache_max_connections,

  Boolean $enable_monitoring                    = $anthill_profile::params::enable_monitoring,
  String $monitoring_location                   = $anthill_profile::params::monitoring_location,

  Boolean $debug                                = $anthill::debug,

  String $internal_broker_location              = $anthill_profile::params::internal_broker_location,
  String $pubsub_location                       = $anthill_profile::params::pubsub_location,

  Optional[String] $discovery_service           = undef,
  Optional[String] $host                        = undef,
  Optional[String] $domain                      = undef,
  Optional[String] $external_domain_name        = undef,
  Optional[String] $internal_domain_name        = undef,

  Optional[Array[String]] $internal_restrict    = undef,
  Optional[Integer] $internal_max_connections   = undef,
  Optional[String] $auth_key_public             = undef,
  Optional[Array[String]] $whitelist            = undef

) inherits anthill_profile::params {

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

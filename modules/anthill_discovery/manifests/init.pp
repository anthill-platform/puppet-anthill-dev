
class anthill_discovery (

  String $default_version                       = $anthill::default_version,

  Enum['present', 'absent'] $ensure             = 'present',
  String $service_name                          = $anthill_discovery::params::service_name,
  String $server_name                           = $anthill_discovery::params::server_name,
  String $package_name                          = $anthill_discovery::params::package_name,
  String $package_directory                     = $anthill_discovery::params::package_directory,

  String $repository_remote_url                 = $anthill_discovery::params::repository_remote_url,
  Optional[String] $private_ssh_key             = undef,
    String $services_init_file                    = $anthill_discovery::params::services_init_file,

  String $disocever_services_location           = $anthill_discovery::params::discover_services_location,
  Integer $discover_services_db                 = $anthill_discovery::params::discover_services_db,
  Integer $discover_services_max_connections    = $anthill_discovery::params::discover_services_max_connections,

  String $token_cache_location                  = $anthill_discovery::params::token_cache_location,
  Integer $token_cache_db                       = $anthill_discovery::params::token_cache_db,
  Integer $token_cache_max_connections          = $anthill_discovery::params::token_cache_max_connections,

  Boolean $enable_monitoring                    = $anthill_discovery::params::enable_monitoring,
  String $monitoring_location                   = $anthill_discovery::params::monitoring_location,

  Boolean $debug                                = $anthill::debug,

  String $internal_broker_location              = $anthill_discovery::params::internal_broker_location,
  String $pubsub_location                       = $anthill_discovery::params::pubsub_location,

  Optional[String] $host                        = undef,
  Optional[String] $domain                      = undef,
  Optional[String] $external_domain_name        = undef,
  Optional[String] $internal_domain_name        = undef,

  Optional[Array[String]] $internal_restrict    = undef,
  Optional[Integer] $internal_max_connections   = undef,
  Optional[String] $auth_key_public             = undef,
  Optional[Array[String]] $whitelist            = undef

) inherits anthill_discovery::params {

  require anthill::common

  concat { $services_init_file:
    ensure => $ensure,
    owner  => $anthill::applications_user,
    group  => $anthill::applications_group,
    mode   => '0440',
    require => File[$anthill::runtime_location]
  }

  concat::fragment { "${anthill::runtime_location}/discovery-services-header":
    target => $services_init_file,
    content => template("anthill_discovery/services_init_header.erb"),
    order => "0"
  }

  concat::fragment { "${anthill::runtime_location}/discovery-services-footer":
    target => $services_init_file,
    content => template("anthill_discovery/services_init_footer.erb"),
    order => "9"
  }

  Anthill::Discovery::Entry <<| tag == "env-${environment}" |>>

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
    dns_first_record => true
  }

}

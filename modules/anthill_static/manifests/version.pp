define anthill_static::version (

  String $package_version,
  String $api_version                                 = $title,
  String $db_location                                 = $anthill_static::db_location,
  String $db_name                                     = $anthill_static::db_name,

  String $token_cache_location                        = $anthill_static::token_cache_location,
  Integer $token_cache_max_connections                = $anthill_static::token_cache_max_connections,
  Integer $token_cache_db                             = $anthill_static::token_cache_db,

  String $rate_cache_location                         = $anthill_static::rate_cache_location,
  Integer $rate_cache_max_connections                 = $anthill_static::rate_cache_max_connections,
  Integer $rate_cache_db                              = $anthill_static::rate_cache_db,

  String $rate_file_upload                            = $anthill_static::rate_file_upload,
  Integer $max_file_size                              = $anthill_static::max_file_size,

  Optional[String] $host                              = $anthill_static::host,
  Optional[String] $domain                            = $anthill_static::domain,

  Boolean $enable_monitoring                          = $anthill_static::enable_monitoring,
  String $monitoring_location                         = $anthill_static::monitoring_location,

  Boolean $debug                                      = $anthill_static::debug,

  String $internal_broker_location                    = $anthill_static::internal_broker_location,
  Optional[Array[String]] $internal_restrict          = $anthill_static::internal_restrict,
  Optional[Integer] $internal_max_connections         = $anthill_static::internal_max_connections,

  String $pubsub_location                             = $anthill_static::pubsub_location,
  Optional[String] $discovery_service                 = $anthill_static::discovery_service,
  Optional[String] $auth_key_public                   = $anthill_static::auth_key_public,

  String $application_arguments                       = '',
  Optional[Integer] $instances                        = undef,
  Optional[Enum['present', 'absent']] $ensure         = undef,
  Optional[String] $runtime_location                  = undef,
  Optional[String] $sockets_location                  = undef

) {

  $db = anthill::ensure_location("mysql database", $db_location, true)
  $token_cache = anthill::ensure_location("token cache redis", $token_cache_location, true)
  $rate_cache = anthill::ensure_location("rate limits redis", $rate_cache_location, true)
  $internal_broker = generate_rabbitmq_url(anthill::ensure_location("internal broker", $internal_broker_location, true), $environment)
  $pubsub = generate_rabbitmq_url(anthill::ensure_location("pubsub", $pubsub_location, true), $environment)

  $args = {
    "db_host" => $db["host"],
    "db_username" => $db["username"],
    "db_name" => $db_name,

    "token_cache_host" => $token_cache["host"],
    "token_cache_port" => $token_cache["port"],
    "token_cache_max_connections" => $token_cache_max_connections,
    "token_cache_db" => $token_cache_db,

    "rate_cache_host" => $rate_cache["host"],
    "rate_cache_port" => $rate_cache["port"],
    "rate_cache_max_connections" => $rate_cache_max_connections,
    "rate_cache_db" => $rate_cache_db,

    "rate_file_upload" => $rate_file_upload,
    "max_file_size" => $max_file_size
  }

  $application_environment = {
    "db_password" => $db["password"]
  }

  anthill::service::version { "${anthill_static::service_name}_${api_version}":
    service_name                                => $anthill_static::service_name,
    server_name                                 => $anthill_static::server_name,
    api_version                                 => $api_version,
    package_name                                => $anthill_static::package_name,
    package_version                             => $package_version,
    args                                        => $args,


    host                                        => $host,
    domain                                      => $domain,
    ensure                                      => $ensure,

    enable_monitoring                           => $enable_monitoring,
    monitoring_location                         => $monitoring_location,
    debug                                       => $debug,

    internal_broker                             => $internal_broker,
    internal_restrict                           => $internal_restrict,
    internal_max_connections                    => $internal_max_connections,

    pubsub                                      => $pubsub,
    discovery_service                           => $discovery_service,
    auth_key_public                             => $auth_key_public,

    instances                                   => $instances,
    runtime_location                            => $runtime_location,
    sockets_location                            => $sockets_location,
    application_arguments                       => $application_arguments,
    application_environment                     => $application_environment,

    require                                     => Anthill::Api::Version[$api_version]

  }
}
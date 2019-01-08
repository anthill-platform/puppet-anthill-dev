define anthill_leaderboard::version (

  String $package_version,
  String $api_version                                 = $title,
  String $db_location                                 = $anthill_leaderboard::db_location,
  String $db_name                                     = $anthill_leaderboard::db_name,

  String $token_cache_location                        = $anthill_leaderboard::token_cache_location,
  Integer $token_cache_max_connections                = $anthill_leaderboard::token_cache_max_connections,
  Integer $token_cache_db                             = $anthill_leaderboard::token_cache_db,

  Optional[String] $host                              = $anthill_leaderboard::host,
  Optional[String] $domain                            = $anthill_leaderboard::domain,

  Boolean $enable_monitoring                          = $anthill_leaderboard::enable_monitoring,
  String $monitoring_location                         = $anthill_leaderboard::monitoring_location,

  Boolean $debug                                      = $anthill_leaderboard::debug,

  String $internal_broker_location                    = $anthill_leaderboard::internal_broker_location,
  Optional[Array[String]] $internal_restrict          = $anthill_leaderboard::internal_restrict,
  Optional[Integer] $internal_max_connections         = $anthill_leaderboard::internal_max_connections,

  String $pubsub_location                             = $anthill_leaderboard::pubsub_location,
  Optional[String] $discovery_service                 = $anthill_leaderboard::discovery_service,
  Optional[String] $auth_key_public                   = $anthill_leaderboard::auth_key_public,

  String $application_arguments                       = '',
  Optional[Integer] $instances                        = undef,
  Optional[Enum['present', 'absent']] $ensure         = undef,
  Optional[String] $runtime_location                  = undef,
  Optional[String] $sockets_location                  = undef

) {

  $db = anthill::ensure_location("mysql database", $db_location, true)
  $token_cache = anthill::ensure_location("token cache redis", $token_cache_location, true)
  $internal_broker = generate_rabbitmq_url(anthill::ensure_location("internal broker", $internal_broker_location, true), $environment)
  $pubsub = generate_rabbitmq_url(anthill::ensure_location("pubsub", $pubsub_location, true), $environment)




  $args = {
    "db_host" => $db["host"],
    "db_username" => $db["username"],
    "db_name" => $db_name,
    "token_cache_host" => $token_cache["host"],
    "token_cache_port" => $token_cache["port"],
    "token_cache_max_connections" => $token_cache_max_connections,
    "token_cache_db" => $token_cache_db
  }

  $application_environment = {
    "db_password" => $db["password"]
  }

  anthill::service::version { "${anthill_leaderboard::service_name}_${api_version}":
    service_name                                => $anthill_leaderboard::service_name,
    server_name                                 => $anthill_leaderboard::server_name,
    api_version                                 => $api_version,
    package_name                                => $anthill_leaderboard::package_name,
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
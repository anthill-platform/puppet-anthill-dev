define anthill_game_controller::version (

  String $package_version,
  String $api_version                                 = $title,
  String $sock_directory                              = $anthill_game_controller::sock_directory,
  String $binaries_directory                          = $anthill_game_controller::binaries_directory,
  String $logs_directory                              = $anthill_game_controller::logs_directory,
  Integer $logs_keep_time                             = $anthill_game_controller::logs_keep_time,
  Integer $ports_pool_from                            = $anthill_game_controller::ports_pool_from,
  Integer $ports_pool_to                              = $anthill_game_controller::ports_pool_to,
  String $gs_host                                     = $anthill_game_controller::gs_host,

  String $token_cache_location                        = $anthill_game_controller::token_cache_location,
  Integer $token_cache_max_connections                = $anthill_game_controller::token_cache_max_connections,
  Integer $token_cache_db                             = $anthill_game_controller::token_cache_db,

  Boolean $enable_monitoring                          = $anthill_game_controller::enable_monitoring,
  String $monitoring_location                         = $anthill_game_controller::monitoring_location,

  Boolean $debug                                      = $anthill_game_controller::debug,

  Optional[String] $host                              = $anthill_game_controller::host,
  Optional[String] $domain                            = $anthill_game_controller::domain,

  String $internal_broker_location                    = $anthill_game_controller::internal_broker_location,
  Optional[Array[String]] $internal_restrict          = $anthill_game_controller::internal_restrict,
  Optional[Integer] $internal_max_connections         = $anthill_game_controller::internal_max_connections,

  String $pubsub_location                             = $anthill_game_controller::pubsub_location,
  Optional[String] $discovery_service                 = $anthill_game_controller::discovery_service,
  Optional[String] $auth_key_public                   = $anthill_game_controller::auth_key_public,

  String $application_arguments                       = '',
  Optional[Integer] $instances                        = undef,
  Optional[Enum['present', 'absent']] $ensure         = undef,
  Optional[String] $runtime_location                  = undef,
  Optional[String] $sockets_location                  = undef

) {

  if ! defined(Anthill_game_controller::Version[$api_version]) {
    fail("anthill_game:version { \"${api_version}\": } is not defined. Please define it with appropriate commit")
  }

  $token_cache = anthill::ensure_location("token cache redis", $token_cache_location, true)
  $internal_broker = generate_rabbitmq_url(anthill::ensure_location("internal broker", $internal_broker_location, true), $environment)
  $pubsub = generate_rabbitmq_url(anthill::ensure_location("pubsub", $pubsub_location, true), $environment)

  $args = {
    "logs_path" => $logs_directory,
    "logs_keep_time" => $logs_keep_time,

    "ports_pool_from" => $ports_pool_from,
    "ports_pool_to" => $ports_pool_to,

    "sock_path" => $sock_directory,
    "binaries_path" => $binaries_directory,
    "gs_host" => $gs_host,

    "token_cache_host" => $token_cache["host"],
    "token_cache_port" => $token_cache["port"],
    "token_cache_max_connections" => $token_cache_max_connections,
    "token_cache_db" => $token_cache_db,
  }

  $application_environment = {
  }

  anthill::service::version { "${anthill_game_controller::service_name}_${api_version}":
    service_name                                => $anthill_game_controller::service_name,
    server_name                                 => $anthill_game_controller::server_name,
    api_version                                 => $api_version,
    package_name                                => $anthill_game_controller::package_name,
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
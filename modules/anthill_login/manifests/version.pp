define anthill_login::version (

  String $package_version,
  String $api_version                                 = $title,
  String $db_location                                 = $anthill_login::db_location,
  String $db_name                                     = $anthill_login::db_name,

  String $tokens_location                             = $anthill_login::tokens_location,
  Integer $tokens_max_connections                     = $anthill_login::tokens_max_connections,
  Integer $tokens_db                                  = $anthill_login::tokens_db,

  String $token_cache_location                        = $anthill_login::token_cache_location,
  Integer $token_cache_max_connections                = $anthill_login::token_cache_max_connections,
  Integer $token_cache_db                             = $anthill_login::token_cache_db,

  String $cache_location                              = $anthill_login::cache_location,
  Integer $cache_max_connections                      = $anthill_login::cache_max_connections,
  Integer $cache_db                                   = $anthill_login::cache_db,

  Boolean $enable_monitoring                          = $anthill_login::enable_monitoring,
  String $monitoring_location                         = $anthill_login::monitoring_location,

  Boolean $debug                                      = $anthill_login::debug,

  String $application_keys_secret                     = $anthill_login::application_keys_secret,
  String $auth_key_private                            = $anthill_login::auth_key_private,
  String $auth_key_private_passphrase                 = $anthill_login::auth_key_private_passphrase,

  Optional[String] $host                              = $anthill_login::host,
  Optional[String] $domain                            = $anthill_login::domain,

  String $internal_broker_location                    = $anthill_login::internal_broker_location,
  Optional[Array[String]] $internal_restrict          = $anthill_login::internal_restrict,
  Optional[Integer] $internal_max_connections         = $anthill_login::internal_max_connections,

  String $pubsub_location                             = $anthill_login::pubsub_location,
  Optional[String] $discovery_service                 = $anthill_login::discovery_service,
  Optional[String] $auth_key_public                   = $anthill_login::auth_key_public,
  String $passwords_salt                              = $anthill_login::passwords_salt,

  String $application_arguments                       = '',
  Optional[Integer] $instances                        = undef,
  Optional[Enum['present', 'absent']] $ensure         = undef,
  Optional[String] $runtime_location                  = undef,
  Optional[String] $sockets_location                  = undef
) {

  $db = anthill::ensure_location("mysql database", $db_location, true)
  $tokens = anthill::ensure_location("tokens redis", $tokens_location, true)
  $token_cache = anthill::ensure_location("token cache redis", $token_cache_location, true)
  $cache = anthill::ensure_location("cache redis", $cache_location, true)
  $internal_broker = generate_rabbitmq_url(anthill::ensure_location("internal broker", $internal_broker_location, true), $environment)
  $pubsub = generate_rabbitmq_url(anthill::ensure_location("pubsub", $pubsub_location, true), $environment)

  $args = {
    "db_host" => $db["host"],
    "db_username" => $db["username"],
    "db_name" => $db_name,

    "tokens_host" => $tokens["host"],
    "tokens_port" => $tokens["port"],
    "tokens_max_connections" => $tokens_max_connections,
    "tokens_db" => $tokens_db,

    "token_cache_host" => $token_cache["host"],
    "token_cache_port" => $token_cache["port"],
    "token_cache_max_connections" => $token_cache_max_connections,
    "token_cache_db" => $token_cache_db,

    "cache_host" => $cache["host"],
    "cache_port" => $cache["port"],
    "cache_max_connections" => $cache_max_connections,
    "cache_db" => $cache_db
  }

  $application_environment = {
    "db_password" => $db["password"],
    "private_key_password" => $auth_key_private_passphrase,
    "application_keys_secret" => $application_keys_secret,
    "auth_key_private" => $auth_key_private,
    "passwords_salt" => $passwords_salt
  }

  anthill::service::version { "${anthill_login::service_name}_${api_version}":
    service_name                                => $anthill_login::service_name,
    server_name                                 => $anthill_login::server_name,
    api_version                                 => $api_version,
    package_name                                => $anthill_login::package_name,
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
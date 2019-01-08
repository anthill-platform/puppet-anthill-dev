
class anthill_config::params {

  $service_name = "config"
  $server_name = "anthill.${service_name}.server"
  $package_name = "anthill-${service_name}"
  $package_directory = "anthill/${service_name}"

  $repository_remote_url = "https://github.com/anthill-platform/anthill-config.git"

  $db_location = "mysql-${hostname}"
  $db_name = "${environment}_${service_name}"

  $token_cache_location = "redis-${hostname}"
  $token_cache_max_connections = $anthill::redis_default_max_connections
  $token_cache_db = 4

  $cache_location = "redis-${hostname}"
  $cache_max_connections = $anthill::redis_default_max_connections
  $cache_db = 2

  $enable_monitoring = $anthill::services_enable_monitoring
  $monitoring_location = $anthill::services_monitoring_location

  $internal_broker_location = "rabbitmq-${hostname}"
  $pubsub_location = "rabbitmq-${hostname}"

  $nginx_max_body_size = '1024m'
}
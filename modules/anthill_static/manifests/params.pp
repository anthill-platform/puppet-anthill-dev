
class anthill_static::params {

  $service_name = "static"
  $server_name = "anthill.${service_name}.server"
  $package_name = "anthill-${service_name}"
  $package_directory = "anthill/${service_name}"

  $repository_remote_url = "https://github.com/anthill-platform/anthill-static.git"

  $db_location = "mysql-${hostname}"
  $db_name = "${environment}_${service_name}"

  $token_cache_location = "redis-${hostname}"
  $token_cache_max_connections = $anthill::redis_default_max_connections
  $token_cache_db = 4

  $rate_cache_location = "redis-${hostname}"
  $rate_cache_max_connections = $anthill::redis_default_max_connections
  $rate_cache_db = 5

  $enable_monitoring = $anthill::services_enable_monitoring
  $monitoring_location = $anthill::services_monitoring_location

  $internal_broker_location = "rabbitmq-${hostname}"
  $pubsub_location = "rabbitmq-${hostname}"

  $nginx_max_body_size = '1024m'

  # A limit for static upload for user tuple: (amount, time)
  $rate_file_upload = "10,600"
  # Maximum files size to accept
  $max_file_size = 104857600
}
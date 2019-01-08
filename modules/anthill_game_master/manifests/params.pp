
class anthill_game_master::params {

  $service_name = "game"
  $server_name = "anthill.game.master.server"
  $package_name = "anthill-game-master"
  $package_directory = "anthill/game/master"

  $repository_remote_url = "https://github.com/anthill-platform/anthill-game-master.git"

  $deployments_directory = "${anthill::runtime_location}/${service_name}-deployments"

  $db_location = "mysql-${hostname}"
  $db_name = "${environment}_${service_name}"

  $token_cache_location = "redis-${hostname}"
  $token_cache_max_connections = $anthill::redis_default_max_connections
  $token_cache_db = 4

  $cache_location = "redis-${hostname}"
  $cache_max_connections = $anthill::redis_default_max_connections
  $cache_db = 2

  $rate_cache_location = "redis-${hostname}"
  $rate_cache_max_connections = $anthill::redis_default_max_connections
  $rate_cache_db = 2

  $rate_create_room = "10,60"

  $enable_monitoring = $anthill::services_enable_monitoring
  $monitoring_location = $anthill::services_monitoring_location

  $internal_broker_location = "rabbitmq-${hostname}"
  $pubsub_location = "rabbitmq-${hostname}"

  $nginx_max_body_size = '1024m'

  $party_broker_location = "rabbitmq-${hostname}"
}
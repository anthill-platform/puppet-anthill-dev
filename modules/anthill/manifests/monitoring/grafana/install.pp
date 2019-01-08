
class anthill::monitoring::grafana::install inherits anthill::monitoring::grafana {

  if ($redis_backend_location)
  {
    $redis_backend = anthill::ensure_location("redis backend", $redis_backend_location, false)

    if ($redis_backend) {
      $redis_backend_host = $redis_backend["host"]
      $redis_backend_port = $redis_backend["port"]

      $session = {
        provider        => "redis",
        provider_config => "addr=${redis_backend_host}:${redis_backend_port},pool_size=100,prefix=grafana"
      }
    } else {
      $session = {}
    }

  } else {
    $session = {}
  }

  $mysql_backend = anthill::ensure_location("mysql backend", $mysql_backend_location, true)

  $mysql_backend_host = $mysql_backend["host"]
  $mysql_backend_port = $mysql_backend["port"]

  class { ::grafana:
    cfg => {
      app_mode => $anthill::debug ? {true => 'development', false => 'production'},
      server   => {
        http_addr     => $listen_host,
        http_port     => $listen_port,
        root_url => "${anthill::protocol}://grafana-${environment}.${anthill::external_domain_name}"
      },
      database => {
        url => "mysql://${mysql_backend_username}:${mysql_backend_password}@${mysql_backend_host}:${mysql_backend_port}/${mysql_backend_db}"
      },
      users    => {
        allow_sign_up => false,
      },
      security => {
        admin_user => $admin_username,
        admin_password => $admin_password
      },
      session => $session
    }
  }

}
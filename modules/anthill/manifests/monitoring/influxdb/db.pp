
function anthill::monitoring::influxdb::influx_call_string(
    String $command, String $http_listen_host, Integer $http_listen_port) {
  return "/usr/bin/influx -host ${http_listen_host} -port ${http_listen_port} -execute \"${command}\""
}

function anthill::monitoring::influxdb::call_influx(
    String $name, String $command, String $onlyif, String $http_listen_host, Integer $http_listen_port) {
  $call = anthill::monitoring::influxdb::influx_call_string($command, $http_listen_host, $http_listen_port)

  Service['influxdb'] ->
  exec { $name:
    command => $call,
    unless => $onlyif
  }
}

class anthill::monitoring::influxdb::db inherits anthill::monitoring::influxdb {

  $show_databases = anthill::monitoring::influxdb::influx_call_string(
    "SHOW DATABASES", $http_listen_host, $http_listen_port)

  anthill::monitoring::influxdb::call_influx(
    "Create influxdb database: ${database_name}",
    "CREATE DATABASE ${database_name}",
    "${show_databases} | /bin/grep '^${database_name}'",
    $http_listen_host, $http_listen_port)

  $show_users = anthill::monitoring::influxdb::influx_call_string(
    "SHOW USERS", $http_listen_host, $http_listen_port)

  anthill::monitoring::influxdb::call_influx(
    "Create influxdb user: ${admin_username}",
    "CREATE USER ${admin_username} WITH PASSWORD '${admin_password}' WITH ALL PRIVILEGES",
    "${show_users} | /bin/grep '^${admin_username}'",
    $http_listen_host, $http_listen_port)

  anthill::monitoring::influxdb::call_influx(
    "Create influxdb user: ${application_username}",
    "CREATE USER ${application_username} WITH PASSWORD '${application_password}'; GRANT WRITE ON ${database_name} TO ${application_username}",
    "${show_users} | /bin/grep '^${application_username}'",
    $http_listen_host, $http_listen_port)
}
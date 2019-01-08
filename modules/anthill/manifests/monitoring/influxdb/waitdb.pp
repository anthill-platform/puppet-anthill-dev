
class anthill::monitoring::influxdb::waitdb inherits anthill::monitoring::influxdb {

  exec { 'wait_for_influxdb_socket_to_open':
    command   => "nc -zv ${http_listen_host} ${http_listen_port}",
    unless    => "nc -zv ${http_listen_host} ${http_listen_port}",
    tries     => '3',
    try_sleep => '10',
    require   => Service['influxdb'],
    path      => '/bin:/usr/bin',
  }

}
class anthill::monitoring::influxdb::location inherits anthill::monitoring::influxdb {

  if ($export_location)
  {
    anthill::location { $export_location_name:
      data => {
        "host" => $anthill::internal_fqdn,
        "port" => $http_listen_port,
        "username" => $application_username,
        "password" => $application_password,
        "db" => $database_name
      }
    }
  }

}
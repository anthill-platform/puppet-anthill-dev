class anthill::rabbitmq::location inherits anthill::rabbitmq {

  if ($export_location)
  {
    anthill::location { $export_location_name:
      data => {
        "host" => $anthill::internal_fqdn,
        "port" => $listen_port,
        "username" => $username,
        "password" => $password,
        "environment" => $environment
      }
    }
  }

}
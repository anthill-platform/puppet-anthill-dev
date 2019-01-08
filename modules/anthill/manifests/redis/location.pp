class anthill::redis::location inherits anthill::redis {

  if ($export_location)
  {
    anthill::location { $export_location_name:
      data => {
        "host" => $anthill::internal_fqdn,
        "port" => $listen_port
      }
    }
  }

}
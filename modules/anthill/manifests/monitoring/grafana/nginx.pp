
class anthill::monitoring::grafana::nginx inherits anthill::monitoring::grafana {

  @@anthill::dns::entry { "grafana":
    internal_hostname => "grafana-${environment}.${anthill::internal_domain_name}",
    tag => "internal"
  }

  $external_domain_name = $anthill::external_domain_name

  nginx::resource::server { "${environment}_grafana":
    ensure               => present,
    server_name          => [
      "grafana-${environment}.${external_domain_name}"
    ],
    listen_port          => $anthill::nginx::listen_port,

    ssl                  => $anthill::nginx::ssl,
    ssl_port             => $anthill::nginx::ssl_port,
    ssl_cert             => $anthill::nginx::ssl_cert,
    ssl_key              => $anthill::nginx::ssl_key,

    use_default_location => false,
    index_files          => []
  }

  nginx::resource::location { "${environment}_grafana/":
    ensure               => present,
    location             => "/",
    server               => "${environment}_grafana",
    rewrite_rules        => [],
    proxy                => "http://${$listen_host}:${listen_port}",
    proxy_buffering      => 'off',

    ssl => $anthill::nginx::ssl
  }


}
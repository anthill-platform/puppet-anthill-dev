
class anthill::supervisor::install inherits anthill::supervisor {

  class { '::supervisor':

    inet_http_server => $http_admin_management,
    inet_http_server_port => $http_admin_management ? { true => $http_admin_port, false => undef },
    inet_http_server_username => $http_admin_management ? { true => $http_admin_username, false => undef },
    inet_http_server_password => $http_admin_management ? { true => $http_admin_password, false => undef },

    supervisord_minfds => $minfds
  }

  if ($http_admin_management) {

    if ($domain) {
      $domain_id = $domain
    } else {
      $domain_id = "supervisor-${environment}"
    }

    $external_domain_name = $anthill::external_domain_name

    include '::nginx'

    nginx::resource::server { "${environment}_supervisor":
      ensure               => present,
      server_name          => [
        "${domain_id}.${external_domain_name}"
      ],
      listen_port          => $anthill::nginx::listen_port,

      ssl                  => $anthill::nginx::ssl,
      ssl_port             => $anthill::nginx::ssl_port,
      ssl_cert             => $anthill::nginx::ssl_cert,
      ssl_key              => $anthill::nginx::ssl_key,

      use_default_location => false,
      index_files          => [],
      proxy_http_version => '1.1'
    }

    nginx::resource::location { "${environment}_supervisor/":
      ensure               => present,
      location             => "/",
      server               => "${environment}_supervisor",
      rewrite_rules        => [],
      proxy                => "http://127.0.0.1:${http_admin_port}",
      proxy_buffering      => 'off',

      ssl => $anthill::nginx::ssl,
      proxy_http_version => '1.1'
    }
  }
  else
  {
    nginx::resource::server { "${environment}_supervisor":
      ensure => absent
    }

    nginx::resource::location { "${environment}_supervisor/":
      server => "${environment}_supervisor",
      ensure => absent
    }
  }

}

class anthill::rabbitmq::install inherits anthill::rabbitmq {

  if ($::operatingsystem == 'Debian')
  {
    apt::source { 'debian_8_erlang':
      location => 'https://packages.erlang-solutions.com/debian',
      repos    => 'contrib',
      key => {
        id => '434975BD900CCBE4F7EE1B1ED208507CA14F4FCA',
        content => file("anthill/pgp/erlang_solutions.asc")
      }
    }
  }

  class { ::rabbitmq:
    port              => $listen_port,
    node_ip_address   => $listen_host,
    management_ip_address => $admin_listen_host,
    management_port   => $admin_listen_port,
    management_ssl    => false,
    admin_enable      => $admin_management,
    delete_guest_user => true,
    manage_python => false,
    repos_ensure => true,
    environment_variables => {
      'LC_ALL' => 'en_US.UTF-8',
    }
  }

  rabbitmq_vhost { $environment:
      ensure => present,
  }

  rabbitmq_user { 'admin':
      admin    => true,
      password => $admin_password,
      tags     => ['monitoring'],
  }

  rabbitmq_user { $username:
      admin    => false,
      password => $password,
      tags     => ['monitoring'],
  }

  rabbitmq_user_permissions { "admin@${environment}":
      configure_permission => '.*',
      read_permission      => '.*',
      write_permission     => '.*',
  }

  rabbitmq_user_permissions { "${username}@${environment}":
      configure_permission => '.*',
      read_permission      => '.*',
      write_permission     => '.*',
  }

  if ($admin_management) {

    include anthill::nginx

    $external_domain_name = $anthill::external_domain_name

    nginx::resource::server { "${environment}_rabbitmq":
      ensure               => present,
      server_name          => [
        "rabbitmq-${environment}.${external_domain_name}"
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

    nginx::resource::location { "${environment}_rabbitmq/":
      ensure               => present,
      location             => "/",
      server               => "${environment}_rabbitmq",
      rewrite_rules        => [],
      proxy                => "http://${admin_listen_host}:${admin_listen_port}",
      proxy_buffering      => 'off',

      ssl => $anthill::nginx::ssl
    }

  }
  else
  {
    nginx::resource::server { "${environment}_rabbitmq":
      ensure => 'abscent'
    }

    nginx::resource::location { "${environment}_rabbitmq/":
      ensure => 'abscent'
    }
  }

}
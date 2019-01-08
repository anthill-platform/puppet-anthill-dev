
class anthill::nginx::install inherits anthill::nginx {

  user { $user:
    ensure           => 'present',
    gid              => $anthill::applications_group,
    shell            => '/bin/bash'
  }

  class { '::nginx':
    service_ensure => 'running',
    daemon_user => $user,
    daemon_group => $anthill::applications_group,
    worker_processes => 8,
    worker_connections => 2096,
    worker_rlimit_nofile => 200000,
    proxy_http_version => '1.1'
  }

}
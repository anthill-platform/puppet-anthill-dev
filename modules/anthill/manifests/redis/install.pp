
class anthill::redis::install inherits anthill::redis {

  class { ::redis:
    service_ensure => 'running',
    port => $listen_port,
    databases => $databases_count,
    bind => anthill::local_ip_address(),
    package_ensure => 'latest',
    manage_repo => true
  }
}
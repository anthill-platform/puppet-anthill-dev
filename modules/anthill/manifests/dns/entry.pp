
define anthill::dns::entry (
  $internal_hostname,

  $ensure                 = 'present',
  $internal_ip_address    = anthill::local_ip_address()
) {

  case $anthill::dns::backend {
    "hosts": {

      host { $internal_hostname:
        ensure => $ensure,
        ip => $internal_ip_address,
        tag => "internal"
      }
    }
  }
}
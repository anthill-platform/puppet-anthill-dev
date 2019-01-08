
class anthill::nginx::params {

  $sock_location = "/var/run/${environment}"
  $listen_port = 80

  $user = 'anthill-nginx'
  $password = 'PVWnQVMmak4LQy8e3wrxsi16iVB6bn6r'

  $ssl = $anthill::enable_https

  $ssl_cert = "${anthill::keys::https_keys_location}/${anthill::keys::https_keys_bundle_name}"
  $ssl_key = "${anthill::keys::https_keys_location}/${anthill::keys::https_keys_private_key_name}"

  $ssl_port = 443

}
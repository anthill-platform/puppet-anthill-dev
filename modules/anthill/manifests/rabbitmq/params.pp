
class anthill::rabbitmq::params {

  $username = 'anthill'
  $password = 'anthill'

  $listen_host = anthill::local_ip_address()
  $listen_port = 5672

  $admin_management = true
  $admin_listen_host = anthill::local_ip_address()
  $admin_listen_port = 23234
  $admin_username = 'admin'
  $admin_password = '1234'

}
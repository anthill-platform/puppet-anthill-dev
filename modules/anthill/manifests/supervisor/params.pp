
class anthill::supervisor::params {

  $http_admin_management = false
  $http_admin_username = 'admin'
  $http_admin_password = '1234'
  $http_admin_port = "4545"

  $domain = undef

  $user = $anthill::applications_user
  $minfds = 200000
}
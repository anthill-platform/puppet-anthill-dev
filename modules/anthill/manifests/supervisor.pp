#
# Manage Supervisor - client/server system that allows its users to control a number of processes on
# UNIX-like operating systems
#
# @api private
#
class anthill::supervisor (

  Enum[present, absent] $ensure = present,

  $http_admin_management = $anthill::supervisor::params::http_admin_management,
  $http_admin_port = $anthill::supervisor::params::http_admin_port,
  $http_admin_username = $anthill::supervisor::params::http_admin_username,
  $http_admin_password = $anthill::supervisor::params::http_admin_password,

  $user = $anthill::supervisor::params::user,
  $domain = $anthill::supervisor::params::domain,
  $minfds = $anthill::supervisor::params::minfds

) inherits anthill::supervisor::params {

  anchor { 'anthill::supervisor::begin': } ->

  class { '::anthill::supervisor::install': } ->

  anchor { 'anthill::supervisor::end': }
}
#
# RabbitMQ message broker
#
# @option editor icon data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjM2MiIgaGVpZ2h0PSIyNTAwIiB2aWV3Qm94PSIwIDAgMjU2IDI3MSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCI+PHBhdGggZD0iTTI0NS40NCAxMDguMzA4aC04NS4wOWE3LjczOCA3LjczOCAwIDAgMS03LjczNS03LjczNHYtODguNjhDMTUyLjYxNSA1LjMyNyAxNDcuMjkgMCAxNDAuNzI2IDBoLTMwLjM3NWMtNi41NjggMC0xMS44OSA1LjMyNy0xMS44OSAxMS44OTR2ODguMTQzYzAgNC41NzMtMy42OTcgOC4yOS04LjI3IDguMzFsLTI3Ljg4NS4xMzNjLTQuNjEyLjAyNS04LjM1OS0zLjcxNy04LjM1LTguMzI1bC4xNzMtODguMjQxQzU0LjE0NCA1LjMzNyA0OC44MTcgMCA0Mi4yNCAwSDExLjg5QzUuMzIxIDAgMCA1LjMyNyAwIDExLjg5NFYyNjAuMjFjMCA1LjgzNCA0LjcyNiAxMC41NiAxMC41NTUgMTAuNTZIMjQ1LjQ0YzUuODM0IDAgMTAuNTYtNC43MjYgMTAuNTYtMTAuNTZWMTE4Ljg2OGMwLTUuODM0LTQuNzI2LTEwLjU2LTEwLjU2LTEwLjU2em0tMzkuOTAyIDkzLjIzM2MwIDcuNjQ1LTYuMTk4IDEzLjg0NC0xMy44NDMgMTMuODQ0SDE2Ny42OWMtNy42NDYgMC0xMy44NDQtNi4xOTktMTMuODQ0LTEzLjg0NHYtMjQuMDA1YzAtNy42NDYgNi4xOTgtMTMuODQ0IDEzLjg0NC0xMy44NDRoMjQuMDA1YzcuNjQ1IDAgMTMuODQzIDYuMTk4IDEzLjg0MyAxMy44NDR2MjQuMDA1eiIgZmlsbD0iI0Y2MCIvPjwvc3ZnPg==
#
class anthill::rabbitmq (

  Boolean $export_location                  = true,
  String $export_location_name              = "rabbitmq-${hostname}",

  String $listen_host                       = $anthill::rabbitmq::params::listen_host,
  Integer $listen_port                      = $anthill::rabbitmq::params::listen_port,

  String $username                          = $anthill::rabbitmq::params::username,
  String $password                          = $anthill::rabbitmq::params::password,

  Boolean $admin_management                 = $anthill::rabbitmq::params::admin_management,
  String $admin_listen_host                 = $anthill::rabbitmq::params::admin_listen_host,
  Integer $admin_listen_port                = $anthill::rabbitmq::params::admin_listen_port,
  String $admin_username                    = $anthill::rabbitmq::params::admin_username,
  String $admin_password                    = $anthill::rabbitmq::params::admin_password

) inherits anthill::rabbitmq::params {

  anchor { 'anthill::rabbitmq::begin': } ->

  class { '::anthill::rabbitmq::install': } ->
  class { '::anthill::rabbitmq::location': } ->

  anchor { 'anthill::rabbitmq::end': }
}
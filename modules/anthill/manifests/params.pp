# @api private
class anthill::params {

  $debug = false

  $enable_https = false
  $logging_level = 'info'

  $external_domain_name = 'anthillplatform.org'
  $internal_domain_name = 'anthill.internal'

  $sockets_location = '/tmp'

  $applications_location = '/opt/anthill'

  $runtime_location_dir = "runtime"
  $tools_location_dir = "tools"
  $keys_location_dir = "keys"
  $virtualenv_location_dir = "venv"
  $pyenv_location_dir = "pyenv"
  $index_location_dir = "index"

  $python_version = "3.6.6"

  $services_enable_monitoring = false
  $services_monitoring_location = "influxdb-${hostname}"

  $applications_user = 'anthill'
  # anthill
  $applications_user_password = '$6$4qanSdNuFPMZ4$fLO4Q.XxJ7kjC3BPCeVNAdMmfsCd279VILxkbkMHsRCao4lmlef6tMzUCg9hRCdu3osItXP3E89Gcw.Rqk3uy.'
  $applications_group = 'anthill'

  $ssh_keys_user = 'anthillkeys'
  $ssh_keys_group = 'anthillkeys'

  $default_version = '0.2'

  $redis_default_max_connections = 500
}
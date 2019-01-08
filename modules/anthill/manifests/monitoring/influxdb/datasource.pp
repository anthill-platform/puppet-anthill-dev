
class anthill::monitoring::influxdb::datasource inherits anthill::monitoring::influxdb {

  if ($export_grafana_datasource) {
    $grafana = anthill::ensure_location("grafana location", $grafana_location, true)

    $grafana_host = $grafana["host"]
    $grafana_port = $grafana["port"]

    $grafana_admin_username = $grafana["admin_username"]
    $grafana_admin_password = $grafana["admin_password"]

    @@grafana_datasource { 'influxdb':
      grafana_url      => "http://${grafana_host}:${grafana_port}",
      grafana_user     => $grafana_admin_username,
      grafana_password => $grafana_admin_password,
      type             => 'influxdb',
      url              => "http://${anthill::internal_fqdn}:${http_listen_port}",
      user             => $admin_username,
      password         => $admin_password,
      database         => $database_name,
      access_mode      => 'proxy',
      is_default       => true,
      tag              => ["env-${environment}"]
    }
  }

}
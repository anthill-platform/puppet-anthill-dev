
class anthill::monitoring::grafana::datasources inherits anthill::monitoring::grafana {
  Grafana_datasource <<| tag == "env-${environment}" |>>
}
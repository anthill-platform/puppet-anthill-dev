class anthill::mysql::databases inherits anthill::mysql {

  Mysql_database <<| tag == $export_location_name and tag == "env-${environment}" |>>

  Class['mysql::server'] -> Mysql_database <<| tag == $export_location_name and tag == "env-${environment}" |>>

}
#
# PyPiGIT git-based python package index
#
class anthill::index (
  Enum[present, absent] $ensure                           = present,
  String $cache_directory                                 = "${anthill::index_location}/cache",
  String $repos_location                                  = "${anthill::index_location}/repos.yaml",
  Integer $listen_port                                    = $anthill::index::params::listen_port,
  String $service_name                                    = $anthill::index::params::service_name,
  String $url                                             = "http://localhost:${listen_port}/simple",
) inherits anthill::index::params {

  file { $anthill::index_location:
    ensure => 'directory',
    owner  => $anthill::applications_user,
    group  => $anthill::applications_group,
    mode   => '0766'
  }

  anchor { 'anthill::index::begin': } ->
  class { '::anthill::index::repos': } ->
  class { '::anthill::index::install': } ->
  anchor { 'anthill::index::end': }

}
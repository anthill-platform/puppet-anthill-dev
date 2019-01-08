
define anthill::api::version (
  String $common_package_version,
  String $api_version                           = $title,
  Enum[present, abscent] $ensure                = present,
) {
  $venv = "${anthill::virtualenv_location}/${api_version}"

  $greate_or_eq = $common_package_version =~ /^>=/
  $fixed_common_package_version = $greate_or_eq ? {
    true => regsubst($common_package_version, '>=', ''),
    false => $common_package_version
  }

  $pip_package_version = $ensure ? {
    present => $fixed_common_package_version,
    default  => $ensure,
  }

  anthill::python::virtualenv { $api_version: } -> python::pip { "api_version_${api_version}":
    pkgname => $anthill::common::packge_name,
    virtualenv => $venv,
    ensure => $pip_package_version,
    greater_or_eq => $greate_or_eq,
    extra_index => $anthill::index::url,
    install_args => "--process-dependency-links --no-cache-dir",
    require => Class['anthill::index']
  }
}
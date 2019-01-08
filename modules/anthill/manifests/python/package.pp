
define anthill::python::package (
  String $package_name,
  String $package_version,
  String $api_version,
  Enum[present, abscent] $ensure                = present,
) {

  $venv = "${anthill::virtualenv_location}/${api_version}"

  $greate_or_eq = $package_version =~ /^>=/
  $fixed_package_version = $greate_or_eq ? {
    true => regsubst($package_version, '>=', ''),
    false => $package_version
  }

  $pip_package_version = $ensure ? {
    present => $fixed_package_version,
    default  => $ensure,
  }

  if ! defined(Anthill::Api::Version[$api_version]) {
    fail("Anthill API version ${api_version} is not defined")
  }

  python::pip { $title:
    pkgname => $package_name,
    virtualenv => $venv,
    extra_index => $anthill::index::url,
    ensure => $pip_package_version,
    greater_or_eq => $greate_or_eq,
    install_args => "--process-dependency-links --no-cache-dir"
  }
}
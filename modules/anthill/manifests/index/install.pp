
class anthill::index::install inherits anthill::index {

  require anthill::python

  if ! defined(Class['anthill::supervisor']) {
    fail("class { anthill::supervisor: } is required to setup index ")
  }

  $pypi_args = "--port=${listen_port} --cache-directory=${cache_directory} --public-url=http://localhost:${listen_port} --repos=${repos_location}"
  $venv = "${anthill::virtualenv_location}/default"

  $application_user = $anthill::applications_user
  $application_group = $anthill::application_group

  python::pip { "pypigit":
    virtualenv => $venv,
    ensure => $ensure,
    require => Anthill::Python::Virtualenv["default"]
  } -> file { $cache_directory:
    ensure => 'directory',
    owner  => $application_user,
    group  => $application_group,
    mode   => '0766'
  } -> file { "/etc/systemd/system/${service_name}":
    ensure => $ensure,
    mode => '0770',
    content => template("anthill/pypigit.erb")
  } ~> exec { "${service_name}-systemd-reload":
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

  service { $service_name:
    ensure => $ensure ? {
      'present' => running,
      'absent' => stopped
    },
    provider => systemd,
    enable => true,
    require => File["/etc/systemd/system/${service_name}"]
  }

}
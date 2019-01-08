#
# Installs Python interpreter
#
# @api private
#
class anthill::python inherits anthill {

  $virtualenv_path = [ "${pyenv_location}/versions/${python_version}/bin", '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ]
  $pyenv_path = [ "${pyenv_location}/bin", '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ]
  $pypi_index = ""

  file { $virtualenv_location:
    ensure => 'directory',
    owner  => $anthill::applications_user,
    group  => $anthill::applications_group,
    mode   => '0760'
  } -> # install the pyenv
  vcsrepo { $pyenv_location:
    ensure   => present,
    owner    => $applications_user,
    group    => $applications_group,
    provider => 'git',
    source   => 'https://github.com/pyenv/pyenv.git',
    revision => 'v1.2.7'
  } -> # install the python of ${python_version}
  exec { "python_${python_version}_install":
    command     => "pyenv install ${python_version}",
    user        => $applications_user,
    group       => $applications_group,
    creates     => "${pyenv_location}/versions/${python_version}",
    path        => $pyenv_path,
    cwd         => '/tmp',
    environment => [
      "PYENV_ROOT=${pyenv_location}"
    ]
  } -> # install virtualenv for ${python_version}
  exec { "python_${python_version}_virtualenv":
    command     => "pip install --upgrade pip setuptools virtualenv",
    user        => $applications_user,
    group       => $applications_group,
    creates     => "${pyenv_location}/versions/${python_version}/bin/virtualenv",
    path        => $virtualenv_path,
    cwd         => '/tmp'
  }

  if ($::operatingsystem == 'Debian' and $::operatingsystemmajrelease == '9') {
    $libmysqlclientdev_name = 'default-libmysqlclient-dev'
  } else {
    $libmysqlclientdev_name = 'libmysqlclient-dev'
  }
}
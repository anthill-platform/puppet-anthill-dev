
define anthill::python::virtualenv {
  require anthill::python

  $path = "${anthill::virtualenv_location}/${title}"

  $virtualenv_path = [ "${anthill::pyenv_location}/versions/${anthill::python_version}/bin", '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ]

  exec { "python_${environment}_virtualenv_${title}":
    command     => "virtualenv ${path}",
    user        => $anthill::applications_user,
    group       => $anthill::applications_group,
    creates     => "${path}/bin/activate",
    path        => $virtualenv_path,
    cwd         => '/tmp'
  } -> # create a reliable symlink to site-packages dir of that virtualenv
  exec { "python_${environment}_${title}_symlink":
    command => "ln -s `${path}/bin/python -c \"from distutils import sysconfig; print(sysconfig.get_python_lib())\"` packages",
    creates => "${path}/packages",
    cwd => $path,
    path => [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ]
  }

}
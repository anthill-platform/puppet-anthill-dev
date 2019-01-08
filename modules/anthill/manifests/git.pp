#
# GIT version control system
#
# @api private
#
class anthill::git inherits anthill {

  if ($::operatingsystem == 'Debian' and $::operatingsystemmajrelease == '8') {
    # apparently, there is
    apt::source { 'debian_8_git':
      location => 'http://ppa.launchpad.net/git-core/ppa/ubuntu',
      release  => 'trusty',
      repos    => 'main',
      key      => {
        'id'     => 'E1DD270288B4E6030699E45FA1715D88E1DF1F24',
        'server' => 'keyserver.ubuntu.com',
      },
      notify => Class['apt::update']
    } -> apt::pin { "git":
      packages => "git",
      origin => "ppa.launchpad.net",
      priority => 1000
    } ~> Class['apt::update'] -> class { git:
      package_ensure => "latest"
    }
  } else {
    class { git:
      package_ensure => "latest"
    }
  }

}
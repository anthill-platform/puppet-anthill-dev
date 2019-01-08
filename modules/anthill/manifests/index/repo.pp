
define anthill::index::repo (
  String $git_repository_url                                = $title,
  Optional[String] $private_ssh_key                         = undef
) {

  require anthill::index

  $fixed_git_repository_url = regsubst($git_repository_url, "([\:/\'])", "_", 'G')

  concat::fragment { "anthill_index_${fixed_git_repository_url}_url":
    target => $anthill::index::repos_location,
    content => " - url: ${git_repository_url}\n",
    order => "5_${fixed_git_repository_url}_0_url"
  }

  if ($private_ssh_key) {
    $fixed_ssh_key = regsubst($private_ssh_key, "\n", "\n      ", 'G')
    concat::fragment { "anthill_index_${fixed_git_repository_url}_ssh_key":
      target => $anthill::index::repos_location,
      content => "    ssh_key: |\n ${fixed_ssh_key}",
      order => "5_${fixed_git_repository_url}_5_ssh_key",
    }
  }
}
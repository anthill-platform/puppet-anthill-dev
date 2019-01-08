#
# Private keys management (SSH, HTTPS and other)
#
# @option editor icon data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgZGF0YS1wcmVmaXg9ImZhcyIgZGF0YS1pY29uPSJrZXkiIGNsYXNzPSJzdmctaW5saW5lLS1mYSBmYS1rZXkgZmEtdy0xNiIgcm9sZT0iaW1nIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA1MTIgNTEyIj48cGF0aCBmaWxsPSJjdXJyZW50Q29sb3IiIGQ9Ik01MTIgMTc2LjAwMUM1MTIgMjczLjIwMyA0MzMuMjAyIDM1MiAzMzYgMzUyYy0xMS4yMiAwLTIyLjE5LTEuMDYyLTMyLjgyNy0zLjA2OWwtMjQuMDEyIDI3LjAxNEEyMy45OTkgMjMuOTk5IDAgMCAxIDI2MS4yMjMgMzg0SDIyNHY0MGMwIDEzLjI1NS0xMC43NDUgMjQtMjQgMjRoLTQwdjQwYzAgMTMuMjU1LTEwLjc0NSAyNC0yNCAyNEgyNGMtMTMuMjU1IDAtMjQtMTAuNzQ1LTI0LTI0di03OC4wNTljMC02LjM2NSAyLjUyOS0xMi40NyA3LjAyOS0xNi45NzFsMTYxLjgwMi0xNjEuODAyQzE2My4xMDggMjEzLjgxNCAxNjAgMTk1LjI3MSAxNjAgMTc2IDE2MCA3OC43OTggMjM4Ljc5Ny4wMDEgMzM1Ljk5OSAwIDQzMy40ODgtLjAwMSA1MTIgNzguNTExIDUxMiAxNzYuMDAxek0zMzYgMTI4YzAgMjYuNTEgMjEuNDkgNDggNDggNDhzNDgtMjEuNDkgNDgtNDgtMjEuNDktNDgtNDgtNDgtNDggMjEuNDktNDggNDh6Ij48L3BhdGg+PC9zdmc+
#
class anthill::keys (
  # file contents for a public key
  $authentication_public_key = 'puppet:///modules/keys/anthill.pub',
  # file contents and a passphrase for a private key
  $authentication_private_key = 'puppet:///modules/keys/anthill.pem',
  $authentication_private_key_passphrase,

  # a private key for downloading repositories via SSH
  $ssh_private_key = undef,

  # if https enabled, content files for a ssl-bundle and .key are required
  $enable_https = $anthill::enable_https,
  $https_keys_bundle_contents = undef,
  $https_keys_private_key_contents = undef,

  $applications_user = $anthill::applications_user,
  $applications_group = $anthill::applications_group,

  $application_keys_location = "${anthill::keys_location}/.anthill-keys",
  $application_keys_public_name = 'anthill.pub',
  $application_keys_private_name = 'anthill.pem',

  $https_keys_location = "${anthill::keys_location}/.https",
  $https_keys_bundle_name = "https-${environment}.ssl-bundle",
  $https_keys_private_key_name = "https-${environment}.key"
) {

  file { $application_keys_location:
    ensure => 'directory',
    owner  => $applications_user,
    group  => $applications_group,
    mode   => '0400'
  }

  file { "${application_keys_location}/${environment}":
    ensure => 'directory',
    owner  => $applications_user,
    group  => $applications_group,
    mode   => '0400',
    require => File[$application_keys_location]
  }

  if ($authentication_public_key) {
    file { "${application_keys_location}/${environment}/${application_keys_public_name}":
      ensure  => 'present',
      owner   => $applications_user,
      group   => $applications_group,
      mode    => '0400',
      source  => $authentication_public_key,
      require => File["${application_keys_location}/${environment}"]
    }
  }

  if ($ssh_private_key) {
    file { "/home/${applications_user}/.ssh":
      ensure  => 'directory',
      owner   => $applications_user,
      group   => $applications_group,
      mode    => '0400'
    } -> file { "/home/${applications_user}/.ssh/id_rsa":
      ensure  => 'present',
      owner   => $applications_user,
      group   => $applications_group,
      mode    => '0400',
      source  => $ssh_private_key
    }
  }

  if ($authentication_private_key) {
    if ! defined(Class['anthill_login']) {
      fail("There is no reason to deploy private authentication keys to a node without login service. Please either install login service or remote the authentication_private_key parameter")
    }

    file { "${application_keys_location}/${environment}/${application_keys_private_name}":
      ensure => 'present',
      owner => $applications_user,
      group => $applications_group,
      mode   => '0400',
      source => $authentication_private_key,
      require => File["${application_keys_location}/${environment}"]
    }
  }

  if ($enable_https) {
    file { $https_keys_location:
      ensure => 'directory',
      owner  => $applications_user,
      group  => $applications_group,
      mode   => '0400'
    }

    file { "${https_keys_location}/${https_keys_bundle_name}":
      ensure  => 'present',
      owner   => $applications_user,
      group   => $applications_group,
      mode    => '0400',
      source => $https_keys_bundle_contents,
      require => File[$https_keys_location]
    }

    file { "${https_keys_location}/${https_keys_private_key_name}":
      ensure  => 'present',
      owner   => $applications_user,
      group   => $applications_group,
      mode    => '0400',
      source => $https_keys_private_key_contents,
      require => File[$https_keys_location]
    }
  }
}

define anthill::service (

  String $service_name,
  String $package_directory,
  Optional[String] $default_version               = undef,
  Enum[present, absent] $ensure                   = present,

  Optional[String] $repository_remote_url         = undef,
  Optional[String] $private_ssh_key               = undef,

  String $domain                                  = "${service_name}-${environment}",

  String $external_domain_name                    = $anthill::external_domain_name,
  String $internal_domain_name                    = $anthill::internal_domain_name,
  String $internal_broker_location                = "rabbitmq",

  Boolean $export_discovery_entry                 = true,
  Optional[Array[String]] $whitelist              = undef,
  Boolean $dns_first_record                       = false,

  Boolean $nginx_serve_static                     = true,
  Optional[String] $nginx_max_body_size          = undef,
  Hash $nginx_locations                           = {}

) {
  $vhost = "${environment}_${service_name}"

  if ($ensure == 'present') {
    if ($repository_remote_url)
    {
      anthill::index::repo { $repository_remote_url:
        private_ssh_key => $private_ssh_key
      }
    }
  }

  include anthill::nginx

  if ($domain != "")
  {
    $full_domain = "${domain}."
  }
  else
  {
    $full_domain = ""
  }

  $external_location = "${anthill::protocol}://${full_domain}${external_domain_name}"

  # internal network is http-only
  $internal_location = "http://${full_domain}${internal_domain_name}"

  $internal_broker = generate_rabbitmq_url(anthill::ensure_location("internal broker", $internal_broker_location, true))

  if ($internal_broker) {
    $real_dns_locations = {
      "external" => $external_location,
      "internal" => $internal_location,
      "broker" => $internal_broker
    }
  } else {
    $real_dns_locations = {
      "external" => $external_location,
      "internal" => $internal_location
    }
  }

  if ($export_discovery_entry) {
    @@anthill::discovery::entry { "${environment}_$service_name":
      service_name => $service_name,
      locations    => $real_dns_locations,
      ensure       => $ensure,
      first        => $dns_first_record,
      tag => ["env-${environment}"]
    }
  }

  @@anthill::dns::entry { "${full_domain}${internal_domain_name}":
    internal_hostname => "${full_domain}${internal_domain_name}",
    ensure => $ensure,
    tag => ["internal", "env-${environment}"]
  }

  if ($default_version) {
    $default_version_map = "${environment}_${service_name}_${default_version}"
    $default_version_require = Anthill::Service::Version["${service_name}_${default_version}"]
  }
  else {
    $default_version_map = undef
    $default_version_require = undef
  }

  nginx::resource::map { "${environment}_${service_name}":
    string => "\$http_x_api_version",
    ensure => $ensure,
    default => $default_version_map,
    include_files => [],
    require => $default_version_require
  }

  nginx::resource::server { $vhost:
    ensure               => $ensure,
    server_name          => [
      "${full_domain}${external_domain_name}",
      "${full_domain}${internal_domain_name}"
    ],
    listen_port          => $anthill::nginx::listen_port,

    ssl                  => $anthill::nginx::ssl,
    ssl_port             => $anthill::nginx::ssl_port,
    ssl_cert             => $anthill::nginx::ssl_cert,
    ssl_key              => $anthill::nginx::ssl_key,

    locations            => $nginx_locations,
    proxy_http_version => '1.1',

    use_default_location => false,
    index_files          => [],

    client_max_body_size => $nginx_max_body_size
  }

  $headers = [
    'Host $host',
    'X-Real-IP $remote_addr',
    'X-Forwarded-For $proxy_add_x_forwarded_for',
    'Proxy ""',
    'Upgrade $http_upgrade',
    'Connection "upgrade"'
  ]

  if ($whitelist) {
    $location_allow = $whitelist
    $location_deny = ['all']
  } else {
    $location_allow = []
    $location_deny = []
  }

  nginx::resource::location { "nginx_location_${vhost}":
    ensure => $ensure,
    location => "/",
    server => $vhost,
    proxy => "http://\$${environment}_${service_name}",
    ssl => $anthill::nginx::ssl,
    proxy_set_header => $headers,

    location_allow => $location_allow,
    location_deny => $location_deny
  }

  if ($nginx_serve_static and $default_version)
  {
    $packages = "${anthill::virtualenv_location}/${default_version}/packages"

    nginx::resource::location { "nginx_location_${vhost}_static":
      ensure => $ensure,
      location => "/static",
      server => $vhost,
      location_alias => "${packages}/${package_directory}/static",
      index_files => [],
      ssl => $anthill::nginx::ssl,

      location_allow => $location_allow,
      location_deny => $location_deny
    }
  }

}
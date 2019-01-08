#
# Anthill Platform Core Class
#
# @option editor icon data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjEuMWMqnEsAAALdSURBVFhHvZdbTxNBFMf7aPwW+qApUNu6XSjd0tILYIQIEUMTjJ9AxQjGiNFANDwTY4zRR0N41ahAfBA1ilLEFi8JEPVBgoIpwUqaYE3acc/s7LK7Pd1LQ/0nv3TmP2d7zu7MXsYhyxeMxXkhRuq8DeRAjUfEvas4D3HEF4gSXoguspQ7EhMvOV0cemA1gBNlqaUz/5/JZZQioIEFVBuYalqANOd4UDlCkdYSr87Dl3hmcEJkzIENGJHJZHB/YwP1jeCFSN5WAQdrPSTYHFf6t27f0Zz56b7zStsKdB1gA0YMXRsh6+s/iVr3HzwkHz5+QuONqKgA4ExfP0st6dvKChonU+v2ob5hAZ+/fEV9IJ/Ps9Q7wuKA1dXvqA+YXoGl5WXUx4TFXb46jPoylqYA5PM3abzfW1ukWCzSMVnqcQDk5QMlvhrLa2By6gm9zZwur+KpdSJxUvFfvpoxnD41thchCM78x9oabcsqFApk/l2KtuFWxY7FsF0AUCO+1TAFQvYf6ZYK6O7pJcm5eZokl8uJD5+7JJvN0r5a/Rcukc3NX7QNv9DH/k9N2QL8wWbSebyH8I0h4vE1asbOnhugSdSCKRi+PqKJc3nr6eJN9J4qe3UqmgKgqzvBUku6NzaOxplRUQFcg0BmXs+y1JLezCZJvK0DjTfCdgHb239YyvLCjiuHrQJAR9q7iJvz07Zeg1eGlDsErhL2H3osFwCS25AIU3rhvRID3wz6xYthqYDk3FtNv/XoMZZSq6fTzzRxAxcH6Z2g9vSYFvBoYhL1MbW1d5bEwWNZ76kxLSCVXkB9q6/j0Rs3UV/GtIDp5y9QH4CHjyxsHIBPNsyXoQXAjgUbBB5PTKG+VfTrQg8nRNMO2C5hg9UG3pripmi/uDGJLmIB1YZeflnQwYKqxWF/mHBcx16WXhIUUckuyQ5w2SFPOBzew9KWig/ExsWgvxC4u0RS9U0t+1gaJofjH0XsHcGE7LRRAAAAAElFTkSuQmCC
#
class anthill (
  # Default version for all Anthill Services (unless explicitly defined in an corresponding classes)
  String $default_version                                             = $anthill::params::default_version,
  # External domain name, used to give it them to the users (e.g. example.com)
  String $external_domain_name                                        = $anthill::params::external_domain_name,
  # Used for internal commications and DNS resolution, e.g. example.internal
  String $internal_domain_name                                        = $anthill::params::internal_domain_name,
  # Whether export this name as DNS entry or not
  Boolean $export_internal_fqdn                                       = true,
  # Node name in correlation to the Puppet's node, but used for internal communications
  String $internal_fqdn                                               = "${hostname}.${internal_domain_name}",
  # Loggin level for the anthill services
  Enum['info', 'error', 'warning'] $logging_level                     = $anthill::params::logging_level,
  # Debug mode throws debug information to users on exceptions, etc
  Boolean $debug                                                      = $anthill::params::debug,
  # Enable https for services (would require SSL keys)
  Boolean $enable_https                                               = $anthill::params::enable_https,
  # Protocol name for services
  String $protocol                                                    = $enable_https ? { true => 'https', default => 'http'},
  # A directory where UNIX domain sockets will rely
  String $sockets_location                                            = $anthill::params::sockets_location,
  # A directory where the Services directory will rely (see below)
  String $applications_location                                       = $anthill::params::applications_location,
  String $runtime_location                                            = "${applications_location}/${environment}/${anthill::params::runtime_location_dir}",
  String $tools_location                                              = "${applications_location}/${environment}/${anthill::params::tools_location_dir}",
  String $keys_location                                               = "${applications_location}/${environment}/${anthill::params::keys_location_dir}",
  String $virtualenv_location                                         = "${applications_location}/${environment}/${anthill::params::virtualenv_location_dir}",
  String $pyenv_location                                              = "${applications_location}/${environment}/${anthill::params::pyenv_location_dir}",
  String $index_location                                              = "${applications_location}/${environment}/${anthill::params::index_location_dir}",
  # Python version for all services
  String $python_version                                              = $anthill::params::python_version,
  # A username/group in behalf whom the Services will run
  String $applications_user                                           = $anthill::params::applications_user,
  String $applications_group                                          = $anthill::params::applications_group,
  String $applications_user_password                                  = $anthill::params::applications_user_password,
  # Some services may need ssh
  String $ssh_keys_user                                               = $anthill::params::ssh_keys_user,
  String $ssh_keys_group                                              = $anthill::params::ssh_keys_group,
  # How much the services will use the redis connections by default
  Integer $redis_default_max_connections                              = $anthill::params::redis_default_max_connections,
  # A default configuration if the monitoring enabled for all services
  Boolean $services_enable_monitoring                                 = $anthill::params::services_enable_monitoring,
  # Default location of the InfluxDB to push the stats into
  String $services_monitoring_location                                = $anthill::params::services_monitoring_location,

) inherits anthill::params {

  if ($::operatingsystem != 'Debian') {
    fail("Only debian operation system is supported")
  }

  if ($::operatingsystemmajrelease != '8' and $::operatingsystemmajrelease != '9') {
    fail("Only Debian 8 and 9 are supported")
  }

  anchor { 'anthill::begin': } ->
  class { '::anthill::install': } ->
  class { '::anthill::node': } ->
  class { '::anthill::git': } ->
  class { '::anthill::python': } ->
  class { '::anthill::def': } ->
  anchor { 'anthill::end': }

}

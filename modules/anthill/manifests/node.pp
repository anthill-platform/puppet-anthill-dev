
class anthill::node inherits anthill {

  if ($export_internal_fqdn)
  {
    @@anthill::dns::entry { $internal_fqdn:
      internal_hostname => $internal_fqdn,
      tag => ["internal", "env-${environment}"]
    }
  }

}
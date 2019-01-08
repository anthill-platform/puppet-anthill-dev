# This function returns a local IP of the current machine
#
# Please note that this function depends on the evaluation order of Puppet manifests
# In orderd to avoid any issues, please make sure to define anthill::vpn class at the top of the manifest
#

function anthill::local_ip_address() {

  if defined (Class['anthill::vpn']) {
    return $anthill::vpn::ip
  } else {
    return inline_template("<%= scope.lookupvar('::ipaddress_eth0') || '127.0.0.1' -%>")
  }

}
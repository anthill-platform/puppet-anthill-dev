
define anthill::discovery::entry (
  $locations,

  $ensure                   = 'present',
  $service_name             = $title,
  $first                    = false
) {

  if ($ensure == 'present') {
    $location_sorted = sorted_json($locations)

    if ($first) {
      concat::fragment { "${environment}-discovery-service-${service_name}":
        target => $anthill_discovery::services_init_file,
        content => "        \"${service_name}\": ${location_sorted}",
        order => "4_${service_name}",
      }
    } else {
      concat::fragment { "${environment}-discovery-service-${service_name}":
        target => $anthill_discovery::services_init_file,
        content => ",\n        \"${service_name}\": ${location_sorted}",
        order => "5_${service_name}"
      }
    }
  }

}
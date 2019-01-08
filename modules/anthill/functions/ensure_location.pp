#
# Arguments: - String Description
#            - String Location for Anthill::Location resource
#            - Boolean Fail if the location has not been found
#
# This function locates the Anthill::Location resource, either on this node, or on another.
# In case of success, returns hash with location information:
#
# anthill::location { "test":
#   data => {
#     "host" => "test-host"
#   }
# }
#
# $result = anthill::ensure_location("Testing...", "test", true)
# ... $result is { "host" => "test-host" } here

function anthill::ensure_location (String $description, String $location, Boolean $fail = false) {

  if defined(Anthill::Location[$location]) {
    $data = getparam(Anthill::Location[$location], "data")
    return $data
  }

  $query = "Anthill::Location[\"${location}\"]"
  $query_result = query_resources(false, $query, false)

  if (!$query_result[0]) {
    if ($fail) {
      fail("No location '${description}' found: ${location}")
      return false
    }
    warning("No location '${description}' found: ${location}")
    return false
  }

  $first_entry = $query_result[0]
  $parameters = $first_entry["parameters"]
  $data = $parameters["data"]
  return $data
}
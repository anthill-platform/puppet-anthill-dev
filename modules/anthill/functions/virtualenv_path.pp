
function anthill::virtualenv_path(String $api_version) {
    return getparam(Anthill::Python::Virtualenv[$api_version], "path")
}

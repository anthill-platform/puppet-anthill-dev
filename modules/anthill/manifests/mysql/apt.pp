
class anthill::mysql::apt inherits anthill::mysql {

  require ::apt

  apt::source { 'mysql-5.7':
    location => 'http://repo.mysql.com/apt/debian/',
    repos    => 'mysql-5.7',
    include  => {
      'src' => false,
      'deb' => true,
    },
    key => {
      id => 'A4A9406876FCBD3C456770C88C718D3B5072E1F5',
      content => file("anthill/pgp/mysql.asc")
    }
  } -> apt::pin { $mysql_package_name:
    packages => $mysql_package_name,
    origin => "repo.mysql.com",
    priority => 1000
  } ~> Class['apt::update']

}
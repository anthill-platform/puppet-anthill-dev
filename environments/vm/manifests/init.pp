
node 'vm.anthillplatform.org' {

  include anthill::puppetdb

  class { anthill:
    debug => true,
    services_enable_monitoring => true
  }

  class { anthill::keys:
    authentication_public_key => "puppet:///modules/keys/anthill.pub",
    authentication_private_key => "puppet:///modules/keys/anthill.pem",
    authentication_private_key_passphrase => "anthill"
  }

  # core libraries/services
  class { anthill::nginx: }
  class { anthill::mysql: }
  class { anthill::supervisor: }
  class { anthill::rabbitmq: }
  class { anthill::redis: }

  # internal dns management
  class { anthill::dns: }

  # Anthill Commons library
  class { anthill::common: }

  # Anthill Services themselves
  class { anthill_admin: default_version => "0.2" }
  class { anthill_config: default_version => "0.2" }
  class { anthill_discovery: default_version => "0.2" }
  class { anthill_dlc: default_version => "0.2" }
  class { anthill_environment: default_version => "0.2" }
  class { anthill_event: default_version => "0.2" }
  class { anthill_exec: default_version => "0.2" }
  class { anthill_game_master: default_version => "0.2" }
  class { anthill_game_controller: default_version => "0.2" }
  class { anthill_leaderboard: default_version => "0.2" }
  class { anthill_login: default_version => "0.2" }
  class { anthill_message: default_version => "0.2" }
  class { anthill_profile: default_version => "0.2" }
  class { anthill_promo: default_version => "0.2" }
  class { anthill_report: default_version => "0.2" }
  class { anthill_social: default_version => "0.2" }
  class { anthill_static: default_version => "0.2" }
  class { anthill_store: default_version => "0.2" }

  # monitoring
  class { anthill::monitoring::grafana: }
  class { anthill::monitoring::influxdb: }
  class { anthill::monitoring::collectd: }

  # Anthill Commonts library versions
  anthill::common::version { "0.2": source_commit => "b6d126f06eb6beeb5b532b16a3a013ee911c6305" }

  # Anthill Services versions assigned to appropriate commits
  anthill_admin::version { "0.2": source_commit => "ccb5b47432d9b040212d940823b2da0cef8c5a03" }
  anthill_config::version { "0.2": source_commit => "def49544f7db7cf422e4b23f054f3ec713ac59c7" }
  anthill_discovery::version { "0.2": source_commit => "630b7526d1619c76150cd2107edf8d7a2b16bacd" }
  anthill_dlc::version { "0.2": source_commit => "95041ad4cfa037318704a01cefe640a52aa346e3" }
  anthill_environment::version { "0.2": source_commit => "773401a968317469c85e4f8efdf3068ce4c9dde8" }
  anthill_event::version { "0.2": source_commit => "cf99af35d5835e44f884ba82180154e20bdcad9a" }
  anthill_exec::version { "0.2": source_commit => "5510b1fb9fb81f318c2030549674c7c3d26be585" }
  anthill_game_master::version { "0.2": source_commit => "9acfe29d6bf9f59c2baa3d0438c4296a01f8dc89" }
  anthill_game_controller::version { "0.2": source_commit => "f1fa1f166e2e4a19bf00dee72137e282f46f4af0" }
  anthill_leaderboard::version { "0.2": source_commit => "339dacba3d47179c2e26f1c5e0622ad95d2aa5fb" }
  anthill_login::version { "0.2": source_commit => "1020132daf294ec306db8a46425e8cb5e04e34f0" }
  anthill_message::version { "0.2": source_commit => "0378351628d2ceffc9796b9a255a74181f1fb325" }
  anthill_profile::version { "0.2": source_commit => "c193846dd866f22efe0e6edaee17c5f1561cc838" }
  anthill_promo::version { "0.2": source_commit => "17dcb5493c09f06c9abfc602fc3344cbbe3e72e7" }
  anthill_report::version { "0.2": source_commit => "0cab78eaeefc7a8740c0f2f321724812a754cc1d" }
  anthill_social::version { "0.2": source_commit => "e1fc582396315bd764909990f009908de4fd7b46" }
  anthill_static::version { "0.2": source_commit => "14a2de5f2c3f44d02b9733a4a845a0e86dcbd709" }
  anthill_store::version { "0.2": source_commit => "9e6afd0fb8b4fd5e944765a8646177ce02561475" }

}

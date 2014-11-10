class perfsonar::mesh_config::install(
  $ensure = $::perfsonar::params::mesh_config_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::mesh_config_packages:
    ensure => $ensure,
  }
}

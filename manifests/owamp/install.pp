class perfsonar::owamp::install(
  $ensure = $::perfsonar::params::owamp_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::owamp_packages:
    ensure => $ensure,
  }
}

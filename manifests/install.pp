class perfsonar::install (
  $ensure = $::perfsonar::install_ensure,
) inherits perfsonar::params {
  package { $perfsonar::params::install_packages:
    ensure => $ensure,
  }
}

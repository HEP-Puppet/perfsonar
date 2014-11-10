class perfsonar::bwctl::install(
  $ensure = $::perfsonar::params::bwctl_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::bwctl_packages:
    ensure => $ensure,
  }
}

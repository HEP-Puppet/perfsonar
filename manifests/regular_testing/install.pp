class perfsonar::regular_testing::install(
  $ensure = $::perfsonar::params::regular_testing_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::regular_testing_packages:
    ensure => $ensure,
  }
}

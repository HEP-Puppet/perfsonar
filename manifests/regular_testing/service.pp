class perfsonar::regular_testing::service(
  $ensure = $::perfsonar::params::regular_testing_ensure,
  $enable = $::perfsonar::params::regular_testing_enable,
) inherits perfsonar::params {
  service { 'perfsonar-regulartesting':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    pattern    => 'perfSONAR_PS Regular Testing',
    require    => [
      Package['perl-perfSONAR_PS-RegularTesting'],
      Exec['run regular testing configuration script'],
    ],
  }
}

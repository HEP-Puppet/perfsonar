class perfsonar::regular_testing::service(
  $ensure = $::perfsonar::params::regular_testing_ensure,
  $enable = $::perfsonar::params::regular_testing_enable,
) inherits perfsonar::params {
  service { 'regular_testing':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => false,
    hasrestart => true,
    pattern    => 'perfSONAR_PS Regular Testing',
    require    => Exec['run regular testing configuration script'],
  }
}

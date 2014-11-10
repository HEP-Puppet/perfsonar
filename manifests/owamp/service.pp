class perfsonar::owamp::service(
  $ensure = $::perfsonar::params::owamp_ensure,
  $enable = $::perfsonar::params::owamp_enable,
) inherits perfsonar::params {
  service { 'owampd':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => false,
    hasrestart => true,
  }
}

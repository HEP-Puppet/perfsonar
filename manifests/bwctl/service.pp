class perfsonar::bwctl::service(
  $ensure = $::perfsonar::params::bwctl_ensure,
  $enable = $::perfsonar::params::bwctl_enable,
) inherits perfsonar::params {
  service { 'bwctld':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => false,
    hasrestart => true,
    require    => Package['bwctl-server'],
  }
}

class perfsonar::bwctl::service(
  $ensure = $::perfsonar::params::bwctl_ensure,
  $enable = $::perfsonar::params::bwctl_enable,
) inherits perfsonar::params {
  service { 'bwctl-server':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    require    => Package['bwctl-server'],
  }
}

class perfsonar::ls_registration_daemon::service(
  $ensure = $::perfsonar::params::ls_registration_daemon_ensure,
  $enable = $::perfsonar::params::ls_registration_daemon_enable,
) inherits perfsonar::params {
  # start stop restart
  service { 'perfsonar-lsregistrationdaemon':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    require    => Package['perfsonar-lsregistrationdaemon'],
  }
}

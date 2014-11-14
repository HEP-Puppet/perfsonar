class perfsonar::ls_registration_daemon::service(
  $ensure = $::perfsonar::params::ls_registration_daemon_ensure,
  $enable = $::perfsonar::params::ls_registration_daemon_enable,
) inherits perfsonar::params {
  # start stop restart
  service { 'ls_registration_daemon':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => false,
    hasrestart => true,
    require    => Package['perl-perfSONAR_PS-LSRegistrationDaemon'],
  }
}

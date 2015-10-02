class perfsonar::ls_registration_daemon::install(
  $ensure = $::perfsonar::params::ls_registration_daemon_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::ls_registration_daemon_packages:
    ensure => $ensure,
    before => File['/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon-logger.conf'],
  }
}

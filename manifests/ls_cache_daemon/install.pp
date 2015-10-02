class perfsonar::ls_cache_daemon::install(
  $ensure = $::perfsonar::params::ls_cache_daemon_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::ls_cache_daemon_packages:
    ensure => $ensure,
    before => File['/opt/perfsonar_ps/ls_cache_daemon/etc/ls_cache_daemon-logger.conf'],
  }
}

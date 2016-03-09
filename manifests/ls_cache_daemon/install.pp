class perfsonar::ls_cache_daemon::install(
  $ensure = $::perfsonar::params::ls_cache_daemon_install_ensure,
) inherits perfsonar::params {
  package { $::perfsonar::params::ls_cache_daemon_packages:
    ensure => $ensure,
    before => File['/etc/perfsonar/lscachedaemon-logger.conf'],
  }
}

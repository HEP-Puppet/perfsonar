class perfsonar::ls_cache_daemon::service(
  $ensure = $::perfsonar::params::ls_cache_daemon_ensure,
  $enable = $::perfsonar::params::ls_cache_daemon_enable,
) inherits perfsonar::params {
  # start stop restart
  service { 'perfsonar-lscachedaemon':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => false,
    pattern    => 'lscachedaemon',
    hasrestart => true,
    require    => Package['perfsonar-lscachedaemon'],
  }
}

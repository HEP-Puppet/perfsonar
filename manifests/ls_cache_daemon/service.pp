class perfsonar::ls_cache_daemon::service(
  $ensure = $::perfsonar::params::ls_cache_daemon_ensure,
  $enable = $::perfsonar::params::ls_cache_daemon_enable,
) inherits perfsonar::params {
  # start stop restart
  service { 'ls_cache_daemon':
    ensure     => $ensure,
    enable     => $enable,
    hasstatus  => false,
    hasrestart => true,
    require    => Package['perl-perfSONAR_PS-LSCacheDaemon'],
  }
}

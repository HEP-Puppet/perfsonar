class perfsonar::ls_cache_daemon::config(
  $snotify = $::perfsonar::params::ls_cache_daemon_snotify,
  $loglvl  = $::perfsonar::params::ls_cache_daemon_loglvl,
  $logger  = $::perfsonar::params::ls_cache_daemon_logger,
  $logfile = $::perfsonar::params::ls_cache_daemon_logfile,
) inherits perfsonar::params {
  $tn = $snotify ? {
    false   => undef,
    default => Service['perfsonar-lscachedaemon'],
  }
  file { '/opt/perfsonar_ps/ls_cache_daemon/etc/ls_cache_daemon-logger.conf':
    ensure  => 'file',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/log4perl-logger.conf.erb"),
    notify  => $tn,
  }
}

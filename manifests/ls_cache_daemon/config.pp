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
  file { '/etc/perfsonar/lscachedaemon-logger.conf':
    ensure  => 'file',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/log4perl-logger.conf.erb"),
    notify  => $tn,
  }
}

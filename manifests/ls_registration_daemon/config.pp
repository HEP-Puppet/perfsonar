class perfsonar::ls_registration_daemon::config(
  $snotify = $::perfsonar::params::ls_registration_daemon_snotify,
  $loglvl  = $::perfsonar::params::ls_registration_daemon_loglvl,
  $logger  = $::perfsonar::params::ls_registration_daemon_logger,
  $logfile = $::perfsonar::params::ls_registration_daemon_logfile,
) inherits perfsonar::params {
  $tn = $snotify ? {
    false   => undef,
    default => Service['perfsonar-lsregistrationdaemon'],
  }
  file { '/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon-logger.conf':
    ensure  => 'file',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/log4perl-logger.conf.erb"),
    notify  => $tn,
  }
}

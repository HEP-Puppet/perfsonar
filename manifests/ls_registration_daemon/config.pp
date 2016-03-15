class perfsonar::ls_registration_daemon::config(
  $snotify    = $::perfsonar::params::ls_registration_daemon_snotify,
  $loglvl     = $::perfsonar::params::ls_registration_daemon_loglvl,
  $logger     = $::perfsonar::params::ls_registration_daemon_logger,
  $logfile    = $::perfsonar::params::ls_registration_daemon_logfile,
  $admininfo  = {},
) inherits perfsonar::params {
  $tn = $snotify ? {
    false   => undef,
    default => Service['perfsonar-lsregistrationdaemon'],
  }
  file { '/etc/perfsonar/lsregistrationdaemon-logger.conf':
    ensure  => 'file',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/log4perl-logger.conf.erb"),
    notify  => $tn,
  }
  
  # TODO: use Augeas to write this config instead of a cat
  exec { 'append_info':
    command => '/bin/cat /etc/perfsonar/toolkit/administrative_info >> /etc/perfsonar/lsregistrationdaemon.conf',
    unless  => '/bin/grep site_project /etc/perfsonar/lsregistrationdaemon.conf > /dev/null',
    require => File['/etc/perfsonar/toolkit/administrative_info'],
  }
}

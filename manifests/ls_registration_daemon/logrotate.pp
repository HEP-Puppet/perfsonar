class perfsonar::ls_registration_daemon::logrotate(
  $logfiles = $::perfsonar::ls_registration_daemon::config::logfile,
  $options  = $::perfsonar::params::ls_registration_daemon_lr_options,
  $order    = $::perfsonar::params::ls_registration_daemon_lr_order,
) inherits perfsonar::params {
  if $::perfsonar::ls_registration_daemon::config::logger == 'Log::Dispatch::FileRotate' {
    warning("configuring logrotate, but ls_registration_daemon's own logger is configured to do log rotation as well, I hope you know what you're doing")
  }
  concat::fragment { 'ps_logrotate_ls_registration_daemon':
    target  => $::perfsonar::params::logrotate_cf,
    content => template("${module_name}/logrotate_fragment.erb"),
    order   => $order,
    require => Class['perfsonar::ls_registration_daemon::config']
  }
}

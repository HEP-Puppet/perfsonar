class perfsonar::regular_testing::logrotate(
  $logfiles = $::perfsonar::regular_testing::config::logfile,
  $options  = $::perfsonar::params::regular_testing_lr_options,
  $order    = $::perfsonar::params::regular_testing_lr_order,
) inherits perfsonar::params {
  if $::perfsonar::regular_testing::config::logger == 'Log::Dispatch::FileRotate' {
    warning("configuring logrotate, but regular_testing's own logger is configured to do log rotation as well, I hope you know what you're doing")
  }
  concat::fragment { 'ps_logrotate_regular_testing':
    target  => $::perfsonar::params::logrotate_cf,
    content => template("${module_name}/logrotate_fragment.erb"),
    order   => $order,
  }
}

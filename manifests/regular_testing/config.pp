# loglevel is a puppet metaparameter, so have to use something else (loglvl)
class perfsonar::regular_testing::config(
  $snotify = $::perfsonar::params::regular_testing_snotify,
  $loglvl  = $::perfsonar::params::regular_testing_loglvl,
  $logger  = $::perfsonar::params::regular_testing_logger,
  $logfile = $::perfsonar::params::regular_testing_logfile,
) inherits perfsonar::params {
  file { '/usr/local/sbin/puppet_perfsonar_configure_regular_testing':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/configure_regular_testing.erb"),
    require => Package['perl-perfSONAR_PS-RegularTesting']
  }
  exec { 'run regular testing configuration script':
    command   => '/usr/local/sbin/puppet_perfsonar_configure_regular_testing',
    logoutput => 'on_failure',
    creates   => '/var/lib/perfsonar/regular_testing/.configured.puppet',
    require   => File['/usr/local/sbin/puppet_perfsonar_configure_regular_testing'],
  }
  $tn = $snotify ? {
      false   => undef,
      default => Service['regular_testing'],
    }
  file { '/opt/perfsonar_ps/regular_testing/etc/regular_testing-logger.conf':
    ensure  => 'file',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/regular_testing-logger.conf.erb"),
    require => Exec['run regular testing configuration script'],
    notify  => $tn,
  }
}

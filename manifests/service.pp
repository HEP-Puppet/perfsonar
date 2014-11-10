class perfsonar::service(
  $config_daemon_ensure   = $::perfsonar::params::config_daemon_ensure,
  $config_daemon_enable   = $::perfsonar::params::config_daemon_enable,
  $config_nic_params      = $::perfsonar::params::config_nic_params,
  $generate_motd_enable   = $::perfsonar::params::generate_motd_enable,
  $htcacheclean_ensure    = $::perfsonar::params::htcacheclean_ensure,
  $htcacheclean_enable    = $::perfsonar::params::htcacheclean_enable,
  $httpd_ensure           = $::perfsonar::params::httpd_ensure,
  $httpd_enable           = $::perfsonar::params::httpd_enable,
  $ls_cache_daemon_ensure = $::perfsonar::params::ls_cache_daemon_ensure,
  $ls_cache_daemon_enable = $::perfsonar::params::ls_cache_daemon_enable,
  $ls_reg_daemon_ensure   = $::perfsonar::params::ls_reg_daemon_ensure,
  $ls_reg_daemon_enable   = $::perfsonar::params::ls_reg_daemon_enable,
  $multipathd_ensure      = $::perfsonar::params::multipathd_ensure,
  $multipathd_enable      = $::perfsonar::params::multipathd_enable,
  $ndt_ensure             = $::perfsonar::params::ndt_ensure,
  $ndt_enable             = $::perfsonar::params::ndt_enable,
  $npad_ensure            = $::perfsonar::params::npad_ensure,
  $npad_enable            = $::perfsonar::params::npad_enable,
  $nscd_ensure            = $::perfsonar::params::nscd_ensure,
  $nscd_enable            = $::perfsonar::params::nscd_enable,
  $ls_bs_client_ensure    = $::perfsonar::params::ls_bs_client_ensure,
  $ls_bs_client_enable    = $::perfsonar::params::ls_bs_client_enable,
  $cassandra_ensure       = $::perfsonar::params::cassandra_ensure,
  $cassandra_enable       = $::perfsonar::params::cassandra_enable,
) inherits perfsonar::params {
  # start stop restart
  service { 'config_daemon':
    ensure     => $config_daemon_ensure,
    enable     => $config_daemon_enable,
    hasstatus  => false,
    hasrestart => true,
  }
  # start (no service, only runs at boot)
  service { 'configure_nic_parameters':
    enable     => $config_nic_params,
    hasstatus  => false,
    hasrestart => false,
  }
  # start stop(nil) restart(start)
# not present in 3.4
#  service { 'dicover_external_address':
#  }
  # start stop(nil) restart (no service, only runs at boot)
  service { 'generate_motd':
    enable     => $generate_motd_enable,
    hasstatus  => false,
    hasrestart => true,
  }
  # start stop status restart condrestart|try-restart(stop start) force-reload|reload(nil)
  service { 'htcacheclean':
    ensure     => $htcacheclean_ensure,
    enable     => $htcacheclean_enable,
    hasstatus  => true,
    hasrestart => true,
  }
  service { $::perfsonar::params::httpd_service:
    ensure     => $httpd_ensure,
    enable     => $httpd_enable,
    hasstatus  => $::perfsonar::params::httpd_hasstatus,
    hasrestart => $::perfsonar::params::httpd_hasrestart,
    require    => Package[$::perfsonar::params::httpd_package],
  }
  # start stop restart
  service { 'ls_cache_daemon':
    ensure     => $ls_cache_daemon_ensure,
    enable     => $ls_cache_daemon_enable,
    hasstatus  => false,
    hasrestart => true,
  }
  # start stop restart
  service { 'ls_registration_daemon':
    ensure     => $ls_reg_daemon_ensure,
    enable     => $ls_reg_daemon_enable,
    hasstatus  => false,
    hasrestart => true,
  }
  # do we need it ???
  # start stop status restart condrestart|try-restart(restart) force-reload|reload
  service { 'multipathd':
    ensure     => $multipathd_ensure,
    enable     => $multipathd_enable,
    hasstatus  => true,
    hasrestart => true,
  }
  # start stop status restart|reload
  service { 'ndt':
    ensure     => $ndt_ensure,
    enable     => $ndt_enable,
    hasstatus  => true,
    hasrestart => true,
  }
# doesn't seem to be used any more
# file { '/opt/perfsonar_ps/toolkit/etc/enabled_services':
#   ensure  => 'present',
#   owner   => 'perfsonar',
#   group   => 'perfsonar',
#   mode    => '0644',
#   content => template("${module_name}/enabled_services.erb"),
# }
  # start stop restart
  service { 'npad':
    ensure     => $npad_ensure,
    enable     => $npad_enable,
    hasstatus  => false,
    hasrestart => true,
  }
  # start stop status restart condrestart|try-restart(restart) force-reload|reload
  service { 'nscd':
    ensure     => $nscd_ensure,
    enable     => $nscd_enable,
    hasstatus  => true,
    hasrestart => true,
  }
  # do we need it ???
  # start stop status restart|reload|force-reload condrestart|try-restart
  service { 'rpcbind':
  }
  # start stop restart
  service { 'simple_ls_bootstrap_client':
    ensure     => $ls_bs_client_ensure,
    enable     => $ls_bs_client_enable,
    hasstatus  => false,
    hasrestart => true,
    pattern    => 'SimpleLSBootStrapClientDaemon.pl',
  }
  service { 'cassandra':
    ensure     => $cassandra_ensure,
    enable     => $cassandra_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}

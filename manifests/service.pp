class perfsonar::service(
) {
  # start stop restart
  service { 'bwctld':
    ensure     => 'running',
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
  }
  # start stop restart
  service { 'config_daemon':
  }
  # start
  service { 'configure_nic_parameters':
  }
  # start stop(nil) restart(start)
  service { 'dicover_external_address':
  }
  # start stop(nil) restart
  service { 'generate_motd':
  }
  # start stop status restart condrestart|try-restart(stop start) force-reload|reload(nil)
  service { 'htcacheclean':
  }
  service { 'httpd':
  }
  # start stop restart
  service { 'ls_cache_daemon':
  }
  # start stop restart
  service { 'ls_registration_daemon':
  }
  # start stop status restart condrestart|try-restart(restart) force-reload|reload
  service { 'multipathd':
  }
  # start stop status restart|reload
  service { 'ndt':
  }
  # start stop restart
  service { 'npad':
  }
  # start stop status restart condrestart|try-restart(restart) force-reload|reload
  service { 'nscd':
  }
  # start stop status restart condrestart|try-restart(restart) force-reload(restart) reload(restart)
  service { 'openct':
  }
  # start stop restart
  service { 'owamp':
  }
  # start stop restart status condrestart|try-restart
  service { 'pcscd':
  }
  # start stop restart
  service { 'perfsonarbuoy_bw_collector':
  }
  # start stop restart
  service { 'perfsonarbuoy_bw_master':
  }
  # start stop restart
  service { 'perfsonarbuoy_ma':
  }
  # start stop restart
  service { 'perfsonarbuoy_owp_collector':
  }
  # start stop restart configure
  service { 'perfsonarbuoy_owp_master':
  }
  # start stop restart
  service { 'PingER':
  }
  # start stop restart condrestart|try-restart(restart) reload(nil) force-reload(restart) status
  service { 'portreserve':
  }
  # start stop status restart|reload|force-reload condrestart|try-restart
  service { 'rpcbind':
  }
  # start stop restart
  service { 'services_init_script':
  }
  # start stop restart
  service { 'simple_ls_bootstrap_client':
  }
  # start stop restart
  service { 'snmp_ma':
  }
  # start stop restart
  service { 'topology_service':
  }
  # start stop restart
  service { 'traceroute_ma':
  }
  # start stop restart
  service { 'traceroute_master':
  }
  # start stop restart
  service { 'traceroute_ondemand_mp':
  }
  # start stop restart
  service { 'tracerouet_scheduler':
  }

  # the following services are installed by perfsonar, but not enabled
  # avahi daemon
  # bluetooth
  # cups
  # nfs
  # nfslock
  # rpcgssd (nfs gss)
  # rpcidmapd
  # rpcsvcgssd
  # snmpd
  # snmptrapd
}

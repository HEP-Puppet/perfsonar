class perfsonar::config(
  $admininfo   = {},
  $agentconfig = {},
) inherits perfsonar::params {
  exec { 'ps_initdb_cacti':
    environment => [ "HOME=/root" ],
    command     => $perfsonar::params::ps_initdb_cmd_cacti,
    logoutput   => 'on_failure',
    require     => Service['mysqld'],
    unless      => '/bin/echo "show databases" | /usr/bin/mysql | /bin/grep -q "^cacti$"',
  }
  exec { 'ps_initdb_psb_bwctl':
    environment => [ "HOME=/root" ],
    command     => $perfsonar::params::ps_initdb_cmd_psb_bwctl,
    logoutput   => 'on_failure',
    require     => Service['mysqld'],
    unless      => '/bin/echo "show databases" | /usr/bin/mysql | /bin/grep -q "^bwctl$"',
  }
  exec { 'ps_initdb_psb_owamp':
    environment => [ "HOME=/root" ],
    command     => $perfsonar::params::ps_initdb_cmd_psb_owamp,
    logoutput   => 'on_failure',
    require     => Service['mysqld'],
    unless      => '/bin/echo "show databases" | /usr/bin/mysql | /bin/grep -q "^owamp$"',
  }
  exec { 'ps_initdb_tr_ma':
    environment => [ "HOME=/root" ],
    command     => $perfsonar::params::ps_initdb_cmd_tr_ma,
    logoutput   => 'on_failure',
    require     => Service['mysqld'],
    unless      => '/bin/echo "show databases" | /usr/bin/mysql | /bin/grep -q "^traceroute_ma$"',
  }
  exec { 'ps_initdb_pinger':
    environment => [ "HOME=/root" ],
    command     => $perfsonar::params::ps_initdb_cmd_pinger,
    logoutput   => 'on_failure',
    require     => Service['mysqld'],
    unless      => '/bin/echo "show databases" | /usr/bin/mysql | /bin/grep -q "^pingerMA$"',
  }
  # the perfsonar kickstart post script replaces all 'yes' values in /etc/sysconfig/readahead to 'no'
  # we do the same here with augeas, it replaces all '"yes"' and 'yes' values to 'no'
  # let's hope they don't start using single quotes in that file,
  # my attempts to update single quoted values as well failed miserably
  # (maybe I should have gone for a simple 'sed -i' exec)
  augeas { 'disable readahead':
    incl    => '/etc/sysconfig/readahead',
    lens    => 'Shellvars.lns',
    context => '/files/etc/sysconfig',
    changes => 'setm readahead *[label()!=\'#comment\'][.=~regexp(\'"?yes"?\')] "no"',
    # we need the onlyif because the above command produces an error if the regex can't find any values
    onlyif  => 'match readahead/*[label()!=\'#comment\'][.=~regexp(\'"?yes"?\')] size > 0',
  }
  # ensure ssh is enabled by default, otherwise saving the configuration in the webinterface (or boot can disable it)
  augeas { 'enable ssh':
     context => '/files/opt/perfsonar_ps/toolkit/etc/enabled_services',
     incl    => '/opt/perfsonar_ps/toolkit/etc/enabled_services',
     lens    => 'Shellvars.lns',
     changes => 'set ssh_enabled "enabled"'
  }
  $site_project = 'pS-NPToolkit-3.3.1'
  file { '/opt/perfsonar_ps/toolkit/etc/administrative_info':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/administrative_info.erb"),
  }
# file { '/opt/perfsonar_ps/toolkit/etc/external_addresses':
#   ensure  => 'present',
#   owner   => 'root',
#   group   => 'root',
#   mode    => '0644',
#   content => template("${module_name}/administrative_info.erb"),
# }
  $agent_options = merge($perfsonar::params::agentconfig, $agentconfig)
  file { '/opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf':
    ensure  => 'present',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/agent_configuration.conf.erb"),
  }
  # ??? run "sudo -u perfsonar /opt/perfsonar_ps/mesh_config/bin/generate_configuration" when agent_configuration.conf is changed
  # it takes a long time to complete, so it's probably not a good idea, it's being run by a cron job every night any way
}

class perfsonar::config(
  $admininfo   = {},
) inherits perfsonar::params {
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
  file { '/opt/perfsonar_ps/toolkit/etc/administrative_info':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/administrative_info.erb"),
    require => Package['perfsonar-toolkit']
  }
  # update owner / permissions on directories
  file { '/var/lib/perfsonar/db_backups':
    ensure => 'directory',
    owner  => 'perfsonar',
    group  => 'perfsonar',
    mode   => '0755',
    require => Package['perfsonar-toolkit']
  }
  file { '/var/lib/perfsonar/log_view':
    ensure => 'directory',
    owner  => 'perfsonar',
    group  => 'perfsonar',
    mode   => '0755',
    require => Package['perfsonar-toolkit']
  }
}

# info for 3.4

#run /opt/perfsonar_ps/toolkit/scripts/upgrade/upgrade_owamp_port_range.sh (new port range)

#for script in %{install_base}/scripts/system_environment/*; do
# run script
#done

# WLCG info: https://twiki.opensciencegrid.org/bin/view/Documentation/InstallUpdatePS
# only use BWCTL and OWAMP

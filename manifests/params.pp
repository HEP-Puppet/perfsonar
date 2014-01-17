class perfsonar::params {
  # package list taken from centos6-netinstall.cfg (from the perfsonar netinstall cd)
  # system packages (already installed on standard installation) and
  # packages that are dependencies of packages in this list have been removed from the original list
  $install_packages = [
    'perl-perfSONAR_PS-Toolkit',
    'perl-perfSONAR_PS-Toolkit-SystemEnvironment',
    'perl-perfSONAR_PS-MeshConfig-Agent',
    'kmod-sk98lin',
    'iperf3',
    'gcc',
    'mysql-devel',
    'device-mapper-multipath',
    'nuttcp',
    'php-gd',
    'php-xml',
    'syslinux',
    'tcptrace',
    'xplot-tcptrace',
  ]
  # other packages in the original kickstart, but left out
  # 'perl-DBD-mysql' doesn't exist, it's called perl-DBD-MySQL
  # 'xkeyboard-config' do we need it, we don't run X ??
  # 'comps-extras' contains images only, do we need it ??

  # init database commands
  # names of db init scripts to run can be found in /opt/perfsonar_ps/toolkit/scripts/initialize_databases
  # we can just run two of them directly, the others call perl scripts which we have run directly
  $ps_initdb_cmd_cacti = '/opt/perfsonar_ps/toolkit/scripts/initialize_cacti_database'
  $ps_initdb_cmd_pinger = '/opt/perfsonar_ps/toolkit/scripts/initialize_pinger_database'
  # the following perl commands ask for the mysql root password on stdin, so we extract it from /root/.my.cnf
  # the original shell scripts (/opt/perfsonar_ps/toolkit/scripts/initialize_* scripts just pipe echo into the
  # perl script and would require a mysql server without a root password
  $ps_initdb_cmd_psb_bwctl = '/bin/sed -n "s/^password=//p" /root/.my.cnf | tr -d "\n\'" | /opt/perfsonar_ps/perfsonarbuoy_ma/bin/bwdb.pl -i root'
  $ps_initdb_cmd_psb_owamp = '/bin/sed -n "s/^password=//p" /root/.my.cnf | tr -d "\n\'" | /opt/perfsonar_ps/perfsonarbuoy_ma/bin/owdb.pl -i root'
  $ps_initdb_cmd_tr_ma = '/bin/sed -n "s/^password=//p" /root/.my.cnf | tr -d "\n\'" | /opt/perfsonar_ps/traceroute_ma/bin/tracedb.pl -i root -c /opt/perfsonar_ps/perfsonarbuoy_ma/etc'

  # apache options
  $hostcert = '/etc/grid-security/hostcert.pem'
  $hostkey = '/etc/grid-security/hostkey.pem'
  $capath = '/etc/grid-security/certificates'
  $clientauth = 'optional'
  $verifydepth = '5'

  # default mesh config
  $agentconfig = {
    mesh => [],
    traceroute_master_conf => '/opt/perfsonar_ps/traceroute_ma/etc/traceroute-master.conf',
    owmesh_conf            => '/opt/perfsonar_ps/perfsonarbuoy_ma/etc/owmesh.conf',
    pinger_landmarks       => '/opt/perfsonar_ps/PingER/etc/pinger-landmarks.xml',
    restart_services       => 0,
    use_toolkit            => 1,
    send_error_emails      => 1,
    skip_redundant_tests   => 1,
  }
  # paths
  case $::osfamily {
    'RedHat': {
      $httpd_dir = '/etc/httpd'
      $mod_dir = "${httpd_dir}/conf.d"
      $conf_dir = "${httpd_dir}/conf.d"
    }
    default: {}
  }
}

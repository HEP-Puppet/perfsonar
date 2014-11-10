class perfsonar::esmond (
  $use_db_module = true,
  $dbname        = $::perfsonar::params::esmond_dbname,
  $dbuser        = $::perfsonar::params::esmond_dbuser,
  $dbpassword    = $::perfsonar::params::esmond_dbpass,
) inherits perfsonar::params {
  if $use_db_module {
    class { 'postgresql::server': }
    postgresql::server::db { $dbname:
      user     => $dbuser,
      password => postgresql_password($dbuser, $dbpassword),
      grant    => 'ALL',
      before   => Exec['run esmond configuration script'],
    }
    # update auth to allow esmond access to the DB
    postgresql::server::pg_hba_rule { 'allow local password auth':
      description => 'allow local authentication using a password',
      type        => 'local',
      database    => 'all',
      user        => 'all',
      auth_method => 'md5',
      # need local md5 auth for esmond user, but the second default pg_hba rule
      # is a generic ident auth for local connections, therefore we need to place
      # this rule before the second default rule
      order       => '002',
      before      => Exec['run esmond configuration script'],
    }
  }

  file { '/opt/esmond/esmond.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/esmond.conf.erb"),
    require => Package['esmond'],
  }
  # the remaining content of this script should be moved here if possible
  file { '/usr/local/sbin/puppet_perfsonar_configure_esmond':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/configure_esmond.erb"),
    require => File['/opt/esmond/esmond.conf'],
  }
  exec { 'run esmond configuration script':
    command   => '/usr/local/sbin/puppet_perfsonar_configure_esmond',
    logoutput => 'on_failure',
    creates   => '/var/lib/esmond/.configured.puppet',
    require   => File['/usr/local/sbin/puppet_perfsonar_configure_esmond'],
  }
}

class perfsonar::apache(
  $hostcert    = $perfsonar::params::hostcert,
  $hostkey     = $perfsonar::params::hostkey,
  $capath      = $perfsonar::params::capath,
  $clientauth  = $perfsonar::params::clientauth,
  $verifydepth = $perfsonar::params::verifydepth,
  $authdn      = [],
) inherits perfsonar::params {

  file { "${perfsonar::params::conf_dir}/tk_redirect.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "RedirectMatch 301 ^/$ http://${::fqdn}/toolkit/\n",
    notify  => Service[$::perfsonar::params::httpd_service],
    require => Package[$::perfsonar::params::httpd_package],
  }

  augeas { 'set mod_ssl params':
    incl    => "${perfsonar::params::mod_dir}/ssl.conf",
    lens    => 'Httpd.lns',
    context => "/files/${perfsonar::params::mod_dir}/ssl.conf/VirtualHost",
    changes => [
      "set *[.='SSLCertificateFile']/arg ${hostcert}",
      "set *[.='SSLCertificateKeyFile']/arg ${hostkey}",
      "set directive[.='SSLCACertificatePath'] 'SSLCACertificatePath'", # create node if not exist
      "set *[.='SSLCACertificatePath']/arg ${capath}", # set value for node
      "set directive[.='SSLVerifyClient'] 'SSLVerifyClient'",
      "set *[.='SSLVerifyClient']/arg ${clientauth}",
      "set directive[.='SSLVerifyDepth'] 'SSLVerifyDepth'",
      "set *[.='SSLVerifyDepth']/arg ${verifydepth}",
      # the changes below are required by the new web interface (perfsonar >= 3.5),
      # but they won't hurt if they are present on older versions as well
      "set directive[.='SSLUserName'] 'SSLUserName'",
      "set *[.='SSLUserName']/arg 'SSL_CLIENT_S_DN_CN'",
      "set directive[.='RewriteEngine'] 'RewriteEngine'",
      "set *[.='RewriteEngine']/arg 'on'",
      "set directive[.='RewriteOptions'] 'RewriteOptions'",
      "set *[.='RewriteOptions']/arg 'Inherit'",
    ],
    notify  => Service[$::perfsonar::params::httpd_service],
    require => Package[$::perfsonar::params::httpd_package],
  }
  $have_auth = $authdn ? {
    undef   => 0,
    default => size($authdn),
  }
  if $have_auth > 0 {
    # new web gui
    $changes35 = versioncmp($perfsonar_version, '3.5') ? {
      /^[01]$/ => [
        "rm Location[arg='\"/toolkit/auth\"']/directive[.='AuthShadow']",
        "rm Location[arg='\"/toolkit/auth\"']/directive[.='AuthType']",
        "rm Location[arg='\"/toolkit/auth\"']/directive[.='AuthName']",
        "rm Location[arg='\"/toolkit/auth\"']/directive[.='Require']",
        "setm Location[arg='\"/toolkit/auth\"'] directive[.='Include'] 'Include'",
        "setm Location[arg='\"/toolkit/auth\"'] *[.='Include']/arg '${perfsonar::params::httpd_dir}/ssl_auth.conf'",
      ],
      default  => [],
    }
    $changes34 = [
      "rm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')]/directive[.='AuthShadow']",
      "rm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')]/directive[.='AuthType']",
      "rm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')]/directive[.='AuthName']",
      "rm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')]/directive[.='Require']",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] directive[.='Include'] 'Include'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] *[.='Include']/arg '${perfsonar::params::httpd_dir}/ssl_auth.conf'",
    ]
    $auges_changes = concat($changes34, $changes35)
    augeas { 'set mod_ssl auth':
      incl    => "${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      lens    => 'Httpd.lns',
      context => "/files/${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      changes => $auges_changes,
      notify  => Service[$::perfsonar::params::httpd_service],
      require => [
        Package[$::perfsonar::params::httpd_package],
        File["${perfsonar::params::httpd_dir}/ssl_auth.conf"],
      ],
    }
    file { "${perfsonar::params::httpd_dir}/ssl_auth.conf":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/ssl_auth.conf.erb"),
      notify  => Service[$::perfsonar::params::httpd_service],
      require => Package[$::perfsonar::params::httpd_package],
    }
  } else {
    $changes35 = versioncmp($perfsonar_version, '3.5') ? {
      /^[01]$/ => [
        "rm Location[arg='\"/toolkit/auth\"']/*[.='Include']",
        "setm Location[arg='\"/toolkit/auth\"'] directive[.='AuthShadow'] 'AuthShadow'",
        "setm Location[arg='\"/toolkit/auth\"'] *[.='AuthShadow']/arg 'on'",
        "setm Location[arg='\"/toolkit/auth\"'] directive[.='AuthType'] 'AuthType'",
        "setm Location[arg='\"/toolkit/auth\"'] *[.='AuthType']/arg 'Basic'",
        "setm Location[arg='\"/toolkit/auth\"'] directive[.='AuthName'] 'AuthName'",
        "setm Location[arg='\"/toolkit/auth\"'] *[.='AuthName']/arg '\"Password Required\"'",
        "setm Location[arg='\"/toolkit/auth\"'] directive[.='Require'] 'Require'",
        "setm Location[arg='\"/toolkit/auth\"'] *[.='Require']/arg[1] 'group'",
        "setm Location[arg='\"/toolkit/auth\"'] *[.='Require']/arg[2] 'psadmin'",
      ],
      default  => [],
    }
    $changes34 = [
      # below should work, but the setm command suffers the same problem as the ones in the "if $have_auth > 0" block
      "rm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')]/*[.='Include']",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] directive[.='AuthShadow'] 'AuthShadow'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] *[.='AuthShadow']/arg 'on'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] directive[.='AuthType'] 'AuthType'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] *[.='AuthType']/arg 'Basic'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] directive[.='AuthName'] 'AuthName'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] *[.='AuthName']/arg '\"Password Required\"'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] directive[.='Require'] 'Require'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] *[.='Require']/arg[1] 'group'",
      "setm Directory[arg=~regexp('\".*/web(-ng)?/root/admin(/.*)?\"?')] *[.='Require']/arg[2] 'psadmin'",
    ]
    $auges_changes = concat($changes34, $changes35)
    # restore apache user auth for perfsonar admin
    # this is problematic as it only restores the configuration file to the state that was known
    # to the author at the time of writing
    # it's safer to reinstall the configuration file from the rpm
    augeas { 'restore mod_ssl auth':
      incl    => "${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      lens    => 'Httpd.lns',
      context => "/files/${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      changes => $auges_changes,
      notify  => Service[$::perfsonar::params::httpd_service],
      require => Package[$::perfsonar::params::httpd_package],
    }
    file { "${perfsonar::params::httpd_dir}/ssl_auth.conf":
      ensure  => 'absent',
      notify  => Service[$::perfsonar::params::httpd_service],
      require => Package[$::perfsonar::params::httpd_package],
    }
  }
}

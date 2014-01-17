class perfsonar::apache(
  $hostcert    = $perfsonar::params::hostcert,
  $hostkey     = $perfsonar::params::hostkey,
  $capath      = $perfsonar::params::capath,
  $clientauth  = $perfsonar::params::clientauth,
  $verifydepth = $perfsonar::params::verifydepth,
  $authdn      = [],
) inherits perfsonar::params {
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
    ],
  }
  $have_auth = $authdn ? {
    undef   => 0,
    default => size($authdn),
  }
  if $have_auth > 0 {
    augeas { 'set mod_ssl auth':
      incl    => "${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      lens    => 'Httpd.lns',
      context => "/files/${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      changes => [
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='AuthShadow']",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='AuthType']",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='AuthName']",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='Require']",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='Include'] 'Include'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='Include']/arg '${perfsonar::params::httpd_dir}/ssl_auth.conf'",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='AuthShadow']",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='AuthType']",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='AuthName']",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='Require']",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='Include'] 'Include'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='Include']/arg '${perfsonar::params::httpd_dir}/ssl_auth.conf'",
        # instead of the set commands above, the setm regex versions below should work as well (they do in augtool),
        # but for some reason they produce an error when run by puppet ('Could not evaluate: missing string argument 2 for setm', no useful debug output either)
        # the rm commands below work, but we shouldn't use them with the single set commands above because they can cause security problems
        # e.g., if the original auth section is removed without from an unexpected directory entry without adding the include
        #"rm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')]/directive[.='AuthShadow']",
        #"rm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')]/directive[.='AuthType']",
        #"rm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')]/directive[.='AuthName']",
        #"rm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')]/directive[.='Require']",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] directive[.='Include'] 'Include'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='Include']/arg '${perfsonar::params::httpd_dir}/ssl_auth.conf'",
      ]
    }
    file { "${perfsonar::params::httpd_dir}/ssl_auth.conf":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/ssl_auth.conf.erb"),
    }
  } else {
    augeas { 'restore mod_ssl auth':
      incl    => "${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      lens    => 'Httpd.lns',
      context => "/files/${perfsonar::params::conf_dir}/apache-toolkit_web_gui.conf",
      changes => [
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='Include']",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='AuthShadow'] 'AuthShadow'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='AuthShadow']/arg 'on'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='AuthType'] 'AuthType'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='AuthType']/arg 'Basic'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='AuthName'] 'AuthName'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='AuthName']/arg '\"Password Required\"'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/directive[.='Require'] 'Require'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='Require']/arg[1] 'group'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='Require']/arg[2] 'wheel'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin\"']/*[.='Require']/arg[3] 'admin'",
        "rm Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='Include']",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='AuthShadow'] 'AuthShadow'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='AuthShadow']/arg 'on'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='AuthType'] 'AuthType'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='AuthType']/arg 'Basic'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='AuthName'] 'AuthName'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='AuthName']/arg '\"Password Required\"'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/directive[.='Require'] 'Require'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='Require']/arg[1] 'group'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='Require']/arg[2] 'wheel'",
        "set Directory[arg='\"/opt/perfsonar_ps/toolkit/web/root/admin/logs\"']/*[.='Require']/arg[3] 'admin'",
        # below should work, but the setm command suffers the same problem as the ones in the "if $have_auth > 0" block
        #"rm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')]/*[.='Include']",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] directive[.='AuthShadow'] 'AuthShadow'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='AuthShadow']/arg 'on'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] directive[.='AuthType'] 'AuthType'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='AuthType']/arg 'Basic'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] directive[.='AuthName'] 'AuthName'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='AuthName']/arg '\"Password Required\"'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] directive[.='Require'] 'Require'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='Require']/arg[1] 'group'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='Require']/arg[2] 'wheel'",
        #"setm Directory[arg=~regexp('.*/web/root/admin(/.*)?\"?')] *[.='Require']/arg[3] 'admin'",
      ]
    }
    file { "${perfsonar::params::httpd_dir}/ssl_auth.conf":
      ensure => 'absent',
    }
  }
}

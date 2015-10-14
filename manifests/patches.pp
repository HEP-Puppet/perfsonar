class perfsonar::patches(
  $patchdir            = $perfsonar::params::patchdir,
  $patchpackage        = $perfsonar::params::patchpackage,
  $patchpackage_ensure = $perfsonar::params::patchpackage_ensure,
) inherits perfsonar::params {
  if $patchpackage {
    package { $patchpackage:
      ensure => $patchpackage_ensure,
      # adding dependency here and not in the exec because it avoids possible
      # dependency failures if $package is not set and this block is
      # not executed
      before => File[$patchdir],
    }
  }
  case $perfsonar_version {
    /^3\.5\.0/: {
      $patches = {
        '01_perfsonar_webservice_auth.patch.3.5.0' => {
          path      => '/opt/perfsonar_ps/toolkit/lib/perfSONAR_PS/NPToolkit/WebService',
          strip     => 1,
         # file itself is part of perl-perfSONAR_PS-Toolkit-Library
         # which is installed as a dependency of perl-perfSONAR_PS-Toolkit
         # therefore we use the latter as a dependency for the patch
          deps      => Package['perl-perfSONAR_PS-Toolkit'],
          checkfile => 'Auth.pm', # relative to path
        },
        '02_perfsonar_webservice_pageauth.patch.3.5.0' => {
          path      => '/opt/perfsonar_ps/toolkit/web-ng/root',
          strip     => 1,
          deps      => Package['perl-perfSONAR_PS-Toolkit'],
          checkfile => 'index.cgi', # relative to path
        }
      }
    }
    default: {
      $patches = {}
    }
  }
  if size(keys($patches)) > 0 {
    file { $patchdir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0750',
    }
    create_resources('perfsonar_apply_patch', $patches)
  }
}

define perfsonar_apply_patch($path, $strip = 0, $deps = [], $checkfile) {
  $patch = "${perfsonar::patches::patchdir}/${name}"
  file { $patch:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => "puppet:///modules/${module_name}/patches/${name}",
    require => File[$perfsonar::patches::patchdir],
    before  => Exec["exec test patch ${name}"],
  }
  exec { "exec test patch ${name}":
    command => "/usr/bin/patch -d ${path} -N -t -p${strip} -i ${patch}",
    require => $deps,
    unless  => "/bin/grep -q '^# puppet perfsonar::patches applied patch: ${name}$' '${path}/${checkfile}'",
    notify  => Service[$::perfsonar::params::httpd_service],
  }
}

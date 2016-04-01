class perfsonar::cleanup(
) {
  if versioncmp($perfsonar_version, '3.5') >= 0 {
    # php is not being used by perfsonar >= 3.5
    # why keep iperf3 devel packages if not needed
    package { [ 'php-xml', 'php-gd', 'iperf3-devel']:
      ensure => 'absent',
    }
    if ! $::perfsonar_systemenvironment {
      # don't remove the following packages if
      # perfsonar-toolkit-systemenv is installed
      # they are dependencies and can't be removed without removing
      # perfsonar-toolkit-systemenv as well
      package { [ 'php-common', 'perl-DBD-MySQL', ]:
        ensure => 'absent',
      }
      # mysql server and client aren't needed in newer versions,
      # but it's too risky to remove them automatically.
    }
  }
}

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
      # perl-perfSONAR_PS-Toolkit-SystemEnvironment is installed
      # they are dependencies and can't be removed without removing
      # perl-perfSONAR_PS-Toolkit-SystemEnvironment as well
      package { [ 'php-common', 'perl-DBD-MySQL', ]:
        ensure => 'absent',
      }
      # mysql server and client aren't needed in newer versions,
      # but it's too risky to remove them automatically.
    }
  }
}

class perfsonar::mesh_config::config(
  $agentconfig = $::perfsonar::params::mesh_config_agent,
) inherits perfsonar::params {
  $agent_options = merge($perfsonar::params::agentconfig, $agentconfig)
  file { '/opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf':
    ensure  => 'present',
    owner   => 'perfsonar',
    group   => 'perfsonar',
    mode    => '0644',
    content => template("${module_name}/agent_configuration.conf.erb"),
    require => Package['perl-perfSONAR_PS-MeshConfig-Agent'],
  }
  # needs notty in sudoers
  exec { 'generate mesh configuration':
    command     => '/usr/bin/sudo -u perfsonar /opt/perfsonar_ps/mesh_config/bin/generate_configuration',
    logoutput   => 'on_failure',
    subscribe   => File['/opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf'],
    require     => [
      Exec['run regular testing configuration script'],
      File['/etc/sudoers.d/perfsonar_mesh_config'],
    ],
    refreshonly => true,
    notify      => Service['regular_testing'],
  }
  file { '/etc/sudoers.d/perfsonar_mesh_config':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
    content => "Defaults!/opt/perfsonar_ps/mesh_config/bin/generate_configuration !requiretty\n",
  }
}

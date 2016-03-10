class perfsonar::mesh_config {
  include 'perfsonar::mesh_config::install'
  include 'perfsonar::mesh_config::config'
  Class['perfsonar::mesh_config::install'] -> Class['perfsonar::mesh_config::config']
}

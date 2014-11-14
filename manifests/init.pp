class perfsonar {
  include 'perfsonar::install'
  include 'perfsonar::config'
  include 'perfsonar::service'
  include 'perfsonar::apache'
  include 'perfsonar::esmond'
  include 'perfsonar::regular_testing'
  include 'perfsonar::mesh_config'
  include 'perfsonar::owamp'
  include 'perfsonar::bwctl'
  include 'perfsonar::ls_registration_daemon'
  include 'perfsonar::ls_cache_daemon'
}

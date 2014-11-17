class perfsonar::ls_cache_daemon {
  include 'perfsonar::ls_cache_daemon::install'
  include 'perfsonar::ls_cache_daemon::config'
  include 'perfsonar::ls_cache_daemon::service'
}

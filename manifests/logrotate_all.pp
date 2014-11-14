class perfsonar::logrotate_all {
  include 'perfsonar::logrotate'
  include 'perfsonar::regular_testing::logrotate'
  include 'perfsonar::ls_registration_daemon::logrotate'
  include 'perfsonar::ls_cache_daemon::logrotate'
}

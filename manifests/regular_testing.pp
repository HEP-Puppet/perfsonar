class perfsonar::regular_testing {
  include 'perfsonar::regular_testing::install'
  include 'perfsonar::regular_testing::config'
  include 'perfsonar::regular_testing::service'
  Class['perfsonar::regular_testing::install'] -> Class['perfsonar::regular_testing::config'] -> 
  Class['perfsonar::regular_testing::service']
}

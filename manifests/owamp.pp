class perfsonar::owamp {
  include 'perfsonar::owamp::install'
  include 'perfsonar::owamp::service'
  Class['perfsonar::owamp::install'] -> Class['perfsonar::owamp::service']
}

class perfsonar::bwctl {
  include 'perfsonar::bwctl::install'
  include 'perfsonar::bwctl::service'
  Class['perfsonar::bwctl::install'] -> Class['perfsonar::bwctl::service']
}

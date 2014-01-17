class perfsonar::install (
  $packages = $perfsonar::params::install_packages,
) inherits perfsonar::params {
  package { $packages: }
}

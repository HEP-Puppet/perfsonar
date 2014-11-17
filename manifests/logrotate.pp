# warning: the perfsonar tools' own logrotation should be disabled before using this class
class perfsonar::logrotate inherits perfsonar::params {
  concat { $::perfsonar::params::logrotate_cf:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  concat::fragment { 'ps_logrotate_header':
    target  => $::perfsonar::params::logrotate_cf,
    content => "# Managed by Puppet\n",
    order   => $::perfsonar::params::lr_header_order,
  }
}

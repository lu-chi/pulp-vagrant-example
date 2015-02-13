##
## https://github.com/pulp/puppet_deployment#examples
##

# dependency classes
class {'::yum':
  defaultrepo => false
}
class { '::qpid::server':
  config_file => '/etc/qpid/qpidd.conf'
}
class { '::mongodb::server': }
class { '::apache': }

# pulp classes
class { '::pulp::repo':
  repo_priority => 15
}
class { '::pulp::server':
  db_name      => 'pulp_database',
  db_seed_list => 'localhost:27017',
}
class { '::pulp::admin':
  verify_ssl => false
}
class { '::pulp::consumer':
  verify_ssl => false
}

# dependency packages
package { [ 'qpid-cpp-server-store', 'python-qpid', 'python-qpid-qmf' ]:
  ensure => 'installed',
}

# ordering
anchor { 'profile::pulp::server::start': }
anchor { 'profile::pulp::server::end': }

Anchor['profile::pulp::server::start']->
Class['::yum::repo::epel']->
Class['::mongodb::server']->
Class['::pulp::repo']->
Class['::qpid::server']->
Package['qpid-cpp-server-store'] -> Package['python-qpid'] -> Package['python-qpid-qmf'] ->
Class['::pulp::server']->
Class['::apache::service']->
Class['::pulp::admin']->
Class['::pulp::consumer']->
Anchor['profile::pulp::server::end']


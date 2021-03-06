# == Class: hubot::install
#
# Installs hubot
# Private class
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class hubot::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  group { 'hubot':
    ensure  => 'present',
    system  => true,
  }

  user { 'hubot':
    ensure      => present,
    comment     => 'Hubot Service User',
    system      => true,
    gid         => 'hubot',
    home        => $::hubot::root_dir,
    shell       => '/bin/bash',
    managehome  => true,
    require     => Group['hubot'],
  }

  if $::hubot::build_deps {
    package { $::hubot::build_deps:
      ensure  => 'installed',
      before  => [ Package['hubot'], Package['coffee-script'] ]
    }
  }

  package { ['hubot', 'coffee-script']:
    ensure    => 'installed',
    require   => User['hubot'],
    provider  => 'npm',
    notify    => Class['hubot::config'],
  }

}

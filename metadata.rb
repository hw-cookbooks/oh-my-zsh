name             'oh-my-zsh'
maintainer       'Heavy Water Ops, LLC'
maintainer_email 'support@heavywater.io'
license          'Apache-2.0'
description      'Installs/Configures oh-my-zsh'
version          '0.4.5'

depends          'git'
depends          'zsh'
depends          'users'

%w( ubuntu debian
    centos redhat fedora ).each do |os|
  supports os
end

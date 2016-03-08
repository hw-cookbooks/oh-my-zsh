name             "oh-my-zsh"
maintainer       "Heavy Water Ops, LLC"
maintainer_email "support@heavywater.io"
license          "Apache 2.0"
description      "Installs/Configures oh-my-zsh"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.4.4"

depends          "git"
depends          "zsh"
depends          "users"

%w( ubuntu debian
    centos redhat fedora ).each do |os|
  supports os
end

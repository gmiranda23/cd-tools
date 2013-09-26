name             'cd-tools'
maintainer       'Opscode Inc.'
maintainer_email "gmiranda@opscode.com"
license          'Apache 2.0'
description      'Installs/Configures cd-tools'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
supports         'ubuntu', '>= 12.04'

depends "apt"
depends "build-essential"
depends "apache2"
depends "java"
depends "git"
depends "virtualbox"
depends "vagrant"
depends "jenkins"
depends "kitchen-jenkins"

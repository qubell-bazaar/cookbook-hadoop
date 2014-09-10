maintainer       "Qubell Inc."
maintainer_email "abutovich@qubell.com"
license          "All rights reserved"
description      "Provision Cloudera Hadoop"
name		 "cloudera"
version          "0.1.0"

depends "yum", '~> 3.3.1'
depends "ntp", '~> 1.6.4'
depends "java", '= 1.26.0'
depends 'mysql', '= 4.0.14'
depends 'database', '= 1.6.0'
depends 'python', '= 1.4.6'
depends 'selinux', '~> 0.6.0'

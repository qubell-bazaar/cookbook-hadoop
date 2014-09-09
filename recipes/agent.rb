#
# Install Cloudera Manager Agent
#

# Requires full CDH stack on each node
include_recipe "cloudera::cdh"

include_recipe "cloudera"
include_recipe "cloudera::cm_repo"

include_recipe "selinux::disabled"


package "wget"
package "mysql"
package "cloudera-manager-agent"
package "cloudera-manager-daemons"
package "hue-plugins"


template "/etc/default/cloudera-scm-agent" do
  source "defaults.erb"
  variables({
    :vars => {:java_home => node.java.java_home }
  })
end

template "/etc/cloudera-scm-agent/config.ini" do
  source "agent/config.ini.erb"
end
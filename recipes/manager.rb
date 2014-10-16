#
# Install Cloudera Manager
#

include_recipe "cloudera"
include_recipe "cloudera::cm_repo"

case node[:platform]
  when "centos"
    include_recipe "selinux::disabled"
  end
case node[:platform_family]
  when "rhel"
    service "iptables" do
      action [ :stop, :disable ]
    end
  when "debian"
    service "ufw" do
      action :stop
    end
  end
  

package "wget"
package "mysql"
package "cloudera-manager-daemons"
package "cloudera-manager-server"
case node[:cloudera][:version]
  when "4"
    package "cloudera-manager-server-db"
  when "5"
    package "cloudera-manager-server-db-2"
  end

template "/etc/default/cloudera-scm-server" do
  source "defaults.erb"
  variables({
    :vars => {
        :java_home => node.java.java_home, 
        :cmf_java_opts => "-Xmx2G -XX:MaxPermSize=256M"
    }
  })
end
service "cloudera-scm-server-db" do
  action [ :enable, :start ]
end

service "cloudera-scm-server" do
  action [ :enable, :start ]
end

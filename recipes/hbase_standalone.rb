#
# Install and launch HBase standalone service
#
include_recipe "cloudera::cdh_repo"

package "hbase-master"

template "/etc/hbase/conf/hbase-env.sh" do
  source "hbase-env.sh.erb"
end

template "/etc/hbase/conf/hbase-site.xml" do
  source "hbase-site.xml.erb"
end

service "hbase-master" do
  action [ :enable, :start ]
end

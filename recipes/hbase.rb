#
# Add Hive to Hadoop cluster
#
require 'resolv'
include_recipe "cloudera"

cookbook_file "/usr/local/bin/hbase.py" do
  source "hbase.py"
  mode "0755"
end

dns_list = []
node.cloudera.datanodes.hosts.each do |host|
  dns_list.push(Resolv.getname(host))
end


execute "python /usr/local/bin/hbase.py #{node.cloudera.manager.host} #{node.cloudera.master.host} '#{dns_list.join(" ")}'  Default"

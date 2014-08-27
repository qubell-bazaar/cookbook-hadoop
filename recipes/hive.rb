#
# Add Hive to Hadoop cluster
#
require 'resolv'
include_recipe "cloudera"

cookbook_file "/usr/local/bin/hive_rc.py" do
  source "hive_rc.py"
  mode "0755"
end

dns_list = []
node.cloudera.datanodes.hosts.each do |host|
  dns_list.push(Resolv.getname(host))
end

execute "python /usr/local/bin/hive_rc.py #{node.cloudera.manager.host} #{node.cloudera.master.host} '#{dns_list.join(" ")}'  Default" do
  retries 3
  retry_delay 5
end

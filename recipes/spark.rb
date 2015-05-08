#
# Add Hive to Hadoop cluster
#
include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/spark.py" do
  source "spark.py"
  mode "0755"
end


execute "python /usr/local/bin/spark.py #{node.cloudera.manager.host} #{node.cloudera.master.host} Default #{node.cloudera.datanodes.hosts.join(" ")} #{node.cloudera.manager.host} #{node.cloudera.master.host}" do
  retries 3
  retry_delay 5
end

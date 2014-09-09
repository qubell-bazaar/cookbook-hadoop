#
# Start Hive metastore
#

cookbook_file "/usr/local/bin/start_hive.py" do
  source "start_hive.py"
  mode "0755"
end

execute "python /usr/local/bin/start_hive.py #{node.cloudera.manager.host} Default"

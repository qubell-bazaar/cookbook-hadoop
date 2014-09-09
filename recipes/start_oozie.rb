# Start services

cookbook_file "/usr/local/bin/start_oozie.py" do
  source "start_oozie.py"
  mode "0755"
end

execute "/usr/local/bin/start_oozie.py #{node.cloudera.manager.host} Default"

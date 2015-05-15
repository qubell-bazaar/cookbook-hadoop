cookbook_file "/usr/local/bin/sqoop.py" do
  source "sqoop.py"
  mode "0755"
end

execute "/usr/local/bin/sqoop.py #{node.cloudera.manager.host} Default #{node.cloudera.master.host}"

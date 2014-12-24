include_recipe "python::pip"

python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/impala.py" do
  source "impala.py"
  mode "0755"
end

execute "/usr/local/bin/impala.py #{node.cloudera.manager.host} Default #{node.cloudera.master.host} #{node.cloudera.datanodes.hosts.join(" ")}" do
  retries 3
  retry_delay 5
end

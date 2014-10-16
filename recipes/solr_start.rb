include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/solr.py" do
  source "solr.py"
  mode "0755"
end

execute "/usr/local/bin/solr.py #{node.cloudera.manager.host} Default #{node.cloudera.datanodes.hosts.join(" ")}"

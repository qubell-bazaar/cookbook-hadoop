include_recipe "python::pip"

python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

python_pip "boto" do
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/import_config.py" do
  source "import_config.py"
  mode "0755"
end

execute "python /usr/local/bin/import_config.py #{node.cloudera.manager.host} Default #{node.aws.accessId} #{node.aws.secretKey} #{node.importBucket} #{node.importKey}"

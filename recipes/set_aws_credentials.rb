include_recipe "cloudera"

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/set_credentials.py" do
  source "set_credentials.py"
  mode "0755"
end

execute "/usr/local/bin/set_credentials.py #{node.cloudera.manager.host} Default #{node.aws.accessId} #{node.aws.secretKey}"

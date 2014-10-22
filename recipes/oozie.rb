include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"
include_recipe "cloudera::oozie_client_pkg"

package "oozie"

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/oozie.py" do
  source "oozie.py"
  mode "0755"
end

execute "/usr/local/bin/oozie.py #{node.cloudera.manager.host} Default #{node.cloudera.jobtracker.host} #{node.cloudera.master.host}" do
  retries 3
  retry_delay 5
end

include_recipe "cloudera::oozie_web_console_pkg"

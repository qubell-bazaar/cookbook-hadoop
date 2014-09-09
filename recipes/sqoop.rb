include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"

package "sqoop2"
package "sqoop"


include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/sqoop.py" do
  source "sqoop.py"
  mode "0755"
end

execute "/usr/local/bin/sqoop.py #{node.cloudera.manager.host} Default #{node.cloudera.master.host}"

#
# Add Hue to Hadoop cluster
#

include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

package "hue"
package "hue-plugins"


cookbook_file "/usr/local/bin/hue.py" do
  source "hue.py"
  mode "0755"
end

execute "python /usr/local/bin/hue.py #{node.cloudera.manager.host} Default" do
  retries 3
  retry_delay 5
end

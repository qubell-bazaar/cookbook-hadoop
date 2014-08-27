#
# Restart Hue
#

cookbook_file "/usr/local/bin/restart_hue.py" do
  source "restart_hue.py"
  mode "0755"
end

execute "python /usr/local/bin/restart_hue.py #{node.cloudera.manager.host} Default"

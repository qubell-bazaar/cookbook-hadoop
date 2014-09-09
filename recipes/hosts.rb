#
# Update /etc/hosts
#

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  mode "0644"
end


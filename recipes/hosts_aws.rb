#
# Update /etc/hosts from AWS/Qubell data
#
require 'resolv'

hosts = {}
hosts.merge! node[:base][:hosts]
node[:base][:hosts_aws].flatten.each do |fqdn|
  ip = Resolv.getaddress(fqdn)
  host = fqdn.split(".")[0] 
  hosts[ip] = [ fqdn, host ]
end
node.set[:base][:hosts] = hosts

include_recipe "cloudera::hosts"

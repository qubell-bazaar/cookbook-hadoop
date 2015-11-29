#
# Install Cloudera Manager repository
#
arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

case node[:platform]
  when "redhat", "centos"
    relnum = node['platform_version'].to_i
  when "amazon"
    relnum = "5"
  end

yum_repository "cloudera-manager" do
  description "Cloudera's Distribution for Cloudera Manager, Version #{node[:cloudera][:cm_version]}"
  baseurl "#{node[:cloudera][:repository_url]}/cm#{node[:cloudera][:cm_version]}/redhat/#{relnum}/#{arch}/cm/#{node[:cloudera][:manager][:version]}/"
  gpgkey "#{node[:cloudera][:repository_url]}/cm#{node[:cloudera][:cm_version]}/redhat/#{relnum}/#{arch}/cm/RPM-GPG-KEY-cloudera"
  enabled true
  action :create
end

#
# Install Cloudera repository
#
arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

case node[:platform]
  when "redhat", "centos"
    relnum = node['platform_version'].to_i
  when "amazon"
    relnum = "5"
  end

yum_repository "cloudera-cdh#{node[:cloudera][:version]}" do
  description "Cloudera's Distribution for Hadoop, Version #{node[:cloudera][:version]}"
  baseurl "#{node[:cloudera][:repository_url]}/cdh#{node[:cloudera][:version]}/redhat/#{relnum}/#{arch}/cdh/#{node.cloudera.hadoop.version}/"
  gpgkey "#{node[:cloudera][:repository_url]}/cdh#{node[:cloudera][:version]}/redhat/#{relnum}/#{arch}/cdh/RPM-GPG-KEY-cloudera"
  enabled true
  action :create
end

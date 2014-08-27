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
yum_key "RPM-GPG-KEY-cloudera" do
 url "#{node[:cloudera][:repository_url]}/cm4/redhat/#{relnum}/#{arch}/cm/RPM-GPG-KEY-cloudera"
end

yum_repository "cloudera-manager" do
  description "Cloudera's Distribution for Cloudera Manager, Version 4"
  url "#{node[:cloudera][:repository_url]}/cm4/redhat/#{relnum}/#{arch}/cm/4/"
  key "RPM-GPG-KEY-cloudera"
  enabled 1
end

yum_key "RPM-GPG-KEY-cloudera" do
  url "#{node[:cloudera][:repository_url]}/cdh4/redhat/#{relnum}/#{arch}/cdh/RPM-GPG-KEY-cloudera"
end

yum_repository "cloudera-cdh4" do
  description "Cloudera's Distribution for Hadoop, Version 4"
  url "#{node[:cloudera][:repository_url]}/cdh4/redhat/#{relnum}/#{arch}/cdh/#{node.cloudera.hadoop.version}/"
  key "RPM-GPG-KEY-cloudera"
  enabled 1
end

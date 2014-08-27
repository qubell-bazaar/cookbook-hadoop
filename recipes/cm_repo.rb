#
# Install Cloudera Manager repository
#
arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

case node[:platform]
when "redhat", "centos"
  relnum = node['platform_version'].to_i

  yum_key "RPM-GPG-KEY-cloudera" do
    url "#{node.cloudera.repository_url}/cm4/redhat/#{relnum}/#{arch}/cm/RPM-GPG-KEY-cloudera"
  end

  yum_repository "cloudera-manager" do
    description "Cloudera Manager"
    url "#{node.cloudera.repository_url}/cm4/redhat/#{relnum}/#{arch}/cm/#{node.cloudera.manager.version}/"
    key "RPM-GPG-KEY-cloudera"
    enabled 1
  end
end

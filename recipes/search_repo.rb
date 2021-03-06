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

yum_repository "cloudera-search" do
  description "Cloudera Search repository"
  baseurl "http://archive.cloudera.com/search/redhat/#{relnum}/#{arch}/search/#{node.cloudera.search.version}/"
  gpgkey "http://archive.cloudera.com/search/redhat/#{relnum}/#{arch}/search/RPM-GPG-KEY-cloudera"
  enabled true
  action :create
end

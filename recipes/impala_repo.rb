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

yum_repository "cloudera-impala" do
  description "Cloudera Impala repository"
  baseurl "http://archive.cloudera.com/impala/redhat/#{relnum}/#{arch}/impala/#{node.cloudera.impala.version}/"
  gpgkey "http://archive.cloudera.com/impala/redhat/#{relnum}/#{arch}/impala/RPM-GPG-KEY-cloudera"
  enabled true
  action :create
end

#
# Install Cloudera repository
#
arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

case node[:platform]
  when "redhat", "centos"
    relnum = node['platform_version'].to_i

    yum_key "RPM-GPG-KEY-search" do
      url "http://archive.cloudera.com/search/redhat/#{relnum}/#{arch}/search/RPM-GPG-KEY-cloudera"
    end

    yum_repository "cloudera-search" do
      description "Cloudera Impala repository"
      url "http://archive.cloudera.com/search/redhat/#{relnum}/#{arch}/search/#{node.cloudera.search.version}/"
      key "RPM-GPG-KEY-search"
      enabled 1
    end
end

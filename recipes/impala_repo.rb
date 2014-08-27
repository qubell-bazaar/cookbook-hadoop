#
# Install Cloudera repository
#
arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

case node[:platform]
  when "redhat", "centos"
    relnum = node['platform_version'].to_i

    yum_key "RPM-GPG-KEY-impala" do
      url "http://archive.cloudera.com/impala/redhat/#{relnum}/#{arch}/impala/RPM-GPG-KEY-cloudera"
    end

    yum_repository "cloudera-impala" do
      description "Cloudera Impala repository"
      url "http://archive.cloudera.com/impala/redhat/#{relnum}/#{arch}/impala/#{node.cloudera.impala.version}/"
      key "RPM-GPG-KEY-impala"
      enabled 1
    end
end

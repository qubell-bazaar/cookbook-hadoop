include_recipe "cloudera"
include_recipe "cloudera::cm_repo"

package "jdk"

cookbook_file "/usr/local/bin/symlink_java.sh" do
  source "symlink_java.sh"
  mode "0755"
end

remote_file "#{Chef::Config[:file_cache_path]}/java-oracle-jdk-compat.rpm" do
    source "https://s3.amazonaws.com/cdh_sandbox/java-oracle-jdk-compat-1.6.0-1jpp.noarch.rpm"
    action :create
end

yum_package "java-oracle-jdk-compat" do
    source "#{Chef::Config[:file_cache_path]}/java-oracle-jdk-compat.rpm"
    action :install
end

execute "/usr/local/bin/symlink_java.sh"

include_recipe "selinux::disabled"
include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"
include_recipe "cloudera::cm_repo"
include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end
include_recipe "cloudera::solr_pkg"
include_recipe "cloudera::impala_pkg"
include_recipe "cloudera::flume_pkg"

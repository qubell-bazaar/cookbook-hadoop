# Install management services

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

directory "/srv/cloudera-scm-eventserver" do
    owner "cloudera-scm"
    group "cloudera-scm"
end

directory "/srv/cloudera-scm-eventserver/log" do
    owner "cloudera-scm"
    group "cloudera-scm"
end

directory "/var/lib/cloudera-scm-eventserver" do
    owner "cloudera-scm"
    group "cloudera-scm"
end

directory "/var/log/cloudera-scm-eventserver" do
    owner "cloudera-scm"
    group "cloudera-scm"
end

cookbook_file "/usr/local/bin/cms.py" do
  source "cms.py"
  mode "0755"
end

execute "/usr/local/bin/cms.py #{node.cloudera.manager.host}"

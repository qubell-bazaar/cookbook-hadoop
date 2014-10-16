include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"
case node[:cloudera][:cdh_version]
  when "4"
    include_recipe "cloudera::impala_repo"
  when "5"
    ["impala", "impala-server", "impala-shell", "impala-state-store", "impala-catalog", "impala-debuginfo", "impala-udf-devel" ].each do |pkg|
      package pkg do
        action :install
        retries 3
        retry_delay 100
      end
    end
    directory "/var/log/statestore" do
      owner "impala"
      group "impala"
    end
    directory "/var/log/impalad" do
      owner "impala"
      group "impala"
    end
    directory "/srv/statestore" do
      owner "impala"
      group "impala"
    end
    directory "/srv/statestore/log" do
      owner "impala"
      group "impala"
    end
    directory "/srv/impalad" do
      owner "impala"
      group "impala"
    end
    directory "/srv/impalad/log" do
      owner "impala"
      group "impala"
    end
  end

#
# Install CDH4 packages
#
include_recipe "cloudera::cdh_repo"

%w{
bigtop-utils
bigtop-jsvc
bigtop-tomcat
hadoop
hadoop-hdfs
hadoop-httpfs
hadoop-mapreduce
hadoop-yarn
hadoop-client
hadoop-0.20-mapreduce
hbase
pig
}.each { |p| package p }

service "iptables" do
  action [ :stop, :disable ]
end

service "oozie" do
  action :disable
end

service "hadoop-httpfs" do
  action :disable
end

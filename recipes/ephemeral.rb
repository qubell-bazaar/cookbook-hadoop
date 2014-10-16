#
# Install CM and CDH ephemeral prelink
#
# TODO! It should be splitted by service
srvs = [
  "cloudera-scm-eventserver",
  "cloudera-scm-server",
  "cloudera-scm-server-db",
  "hadoop-hdfs",
  "hadoop-mapreduce",
  "hadoop-yarn",
  "hadoop-0.20-mapreduce",
  "impala",
  "mysql",
  "oozie",
  "zookeeper",
  "hbase",
  "statestore",
  "flume-ng",
  "cloudera-scm-firehose",
  "cloudera-scm-alertpublisher",
  "impalad"
]

srvs.each do |srv|
  srv_log = "/var/log/" + srv
  srv_lib = "/var/lib/" + srv
  srv_dir = "/srv/" + srv
  srv_dir_log = srv_dir + "/log"

  directory srv_dir_log do
    recursive true
    action :create
  end

  link srv_lib do
    to srv_dir
  end

  link srv_log do
    to srv_dir_log
  end
end

dirs = [
  "/mapred"
]

dirs.each do |dir|
  srv_dir = "/srv" + dir

  directory srv_dir do
    recursive true
    action :create
  end

  link dir do
    to srv_dir
  end
end

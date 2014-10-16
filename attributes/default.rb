#
# Cloudera attributes
#
include_attribute "java"

default['base']['hosts'] = {
  '127.0.0.1' => ['localhost', 'localhost.localdomain', 'localhost4', 'localhost4.localdomain4'],
  '::1'       => ['localhost', 'localhost.localdomain', 'localhost6', 'localhost6.localdomain6']
}
default['base']['hosts_aws'] = []

default[:cloudera][:hadoop][:version]="4.4.0"
default[:cloudera][:version] = node[:cloudera][:hadoop][:version][0]
default[:clousera][:repository_url] = "http://archive.cloudera.com"
default[:cloudera][:hbase][:environment][:java_home] = "/usr/java/jdk6"
default[:cloudera][:hbase][:environment][:hbase_opts] = "-XX:+UseConcMarkSweepGC"

default[:cloudera][:hbase][:properties] = Mash.new

default[:cloudera][:manager][:host] = "127.0.0.1"
default[:cloudera][:manager][:port] = 7182
default[:cloudera][:oozie][:web_console_source] = "http://extjs.com/deploy/ext-2.2.zip"

defaultCluster = {
    :name => "Default",
    :version => "CDH#{node[:cloudera][:version]}",
    :services => {
        :zookeeper => {
            :server => {
                :hosts => [],
                :config => {
                    "maxSessionTimeout" => 60000
                }
            }
        },
        :hdfs => {
            :namenode => {
                :hosts => [],
                :config => {
                    "dfs_name_dir_list" => "/dfs/nn"
                }
            },
            :secondarynamenode => {
                :hosts => [],
                :config => {
                    "fs_checkpoint_dir_list" => "/dfs/snn"
                }
            },
            :datanode => {
                :hosts => [],
                :config => {
                    "dfs_data_dir_list" => "/dfs/dn",
                    "dfs_datanode_du_reserved" => 845511884
                }
            },
            :gateway => {
                :hosts => [],
                :config => {
                    "dfs_client_use_trash" => true
                }
            }
        },
        :mapreduce => {
            :jobtracker => {
                :hosts => [],
                :config => {
                    "jobtracker_mapred_local_dir_list" => "/mapred/jt"
                }
            },
            :tasktracker => {
                :hosts => [],
                :config => {
                    "tasktracker_mapred_local_dir_list" => "/mapred/local"
                }
            }
        }
    }
}

default[:cloudera][:clusters]["default"] = Mash.new(defaultCluster)
default[:cloudera][:clusters_init] = [ "default" ]


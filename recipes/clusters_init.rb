#
# Initialize Hadoop cluster
#
require 'json'
require 'resolv'

depends = {
  "mapreduce" => [ "hdfs" ],
  "hbase" => [ "hdfs", "zookeeper" ]
}

clusters = []
node[:cloudera][:clusters_init].each do |clusterId|
  cluster = {}
  c = node[:cloudera][:clusters][clusterId] 
  cluster["name"] = c["name"]
  cluster["version"] = c["version"]
  cluster["services"] = []
  node[:cloudera][:clusters][clusterId][:services].each do |sname, svalue|
    srv = {}
    srv["name"] = sname + "1"
    srv["type"] = sname.upcase
    roleTypeConfigs = []
    configItems = []
    roles = []
    svalue.each do |rtype, rservice|
      if rtype != "config"
        rservice["hosts"].each_index do |n|
          r = {}
          r["name"] = "#{srv["name"]}_#{rtype.upcase}_#{n+1}"
          r["type"] = rtype.upcase
          r["hostRef"] = { "hostId" => Resolv.getname(Resolv.getaddress(rservice["hosts"][n])) }
          if sname.upcase == "ZOOKEEPER"
            r["config"] = { "items" => [] }
            r["config"]["items"] << { "name" => "serverId", "value" => n+1 }
          end
          roles << r
        end
        if rservice.include? "config"
          rconfig = { "roleType" => rtype.upcase, "items" => [] }
          rservice["config"].each do |k, v|
            rconfig["items"] << { "name" => k, "value" => v } 
          end
          if rconfig["items"].length > 0
            roleTypeConfigs << rconfig
          end
        end
      else
        rservice.each do |k, v|
          configItems << { "name" => k, "value" => v }
        end
      end
    end
    if depends.include? sname
      depends[sname].each do |dep|
        configItems << { "name" => "#{dep}_service", "value" => "#{dep}1" }
      end
    end
    if roles.length > 0
      srv["roles"] = roles
    end
    srv["config"] = { "roleTypeConfigs" => roleTypeConfigs, "items" => configItems }
    cluster["services"] << srv
  end
  clusters << cluster
end

node.set[:cloudera][:clusters_prepared] = clusters

request = { "items" => clusters }.to_json

package "curl"

curl_post = "curl -v -X POST -u admin:admin -H 'Content-Type: application/json'"

execute "init cluster" do
  command "#{curl_post} -d '#{request}' http://#{node.cloudera.manager.host}:7180/api/v2/clusters 2>&1"
end

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

cookbook_file "/usr/local/bin/hdfs.py" do
  source "hdfs.py"
  mode "0755"
end

execute "python /usr/local/bin/hdfs.py #{node.cloudera.manager.host} #{clusters[0]["name"]} format"
# TODO: insert not_if here


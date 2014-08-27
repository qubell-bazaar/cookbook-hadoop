
# Start services
node[:cloudera][:services].each do |s|
  execute "/usr/local/bin/hdfs.py #{node.cloudera.manager.host} #{node[:cloudera][:clusters]["default"]["name"]} start #{s}1"
end


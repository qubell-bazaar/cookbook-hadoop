include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"
case node[:cloudera][:cdh_version]
  when "4"
    include_recipe "cloudera::search_repo"
  end

["search","solr","solr-server","solr-mapreduce","hbase-solr","hbase-solr-indexer"].each do |pkg|
  package pkg do
    action :install
    retries 3
    retry_delay 100
  end
end

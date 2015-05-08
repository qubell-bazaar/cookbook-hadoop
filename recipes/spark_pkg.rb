#
# Add Hive to Hadoop cluster
#

include_recipe "cloudera"
include_recipe "cloudera::cm_repo"

["spark-core", "spark-master", "spark-worker", "spark-python"].each do |pkg|
  package pkg do
    action :install
    retries 3
    retry_delay 100
  end
end

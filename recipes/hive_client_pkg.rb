#
# Add Hive to Hadoop cluster
#

include_recipe "cloudera"
include_recipe "cloudera::cm_repo"


package "hive"

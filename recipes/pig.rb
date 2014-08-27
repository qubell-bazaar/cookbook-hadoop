#
# Add Pig to Hadoop cluster
#

include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"

package "pig"
package "hue-pig"
package "pig-udf-datafu"

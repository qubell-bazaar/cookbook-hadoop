include_recipe "cloudera"
include_recipe "cloudera::cdh_repo"

package "flume-ng"
package "flume-ng-agent"

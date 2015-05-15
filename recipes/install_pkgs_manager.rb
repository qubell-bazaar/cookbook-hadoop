include_recipe "cloudera::hive_rc"
package "oozie"
include_recipe "cloudera::oozie_client_pkg"
include_recipe "cloudera::oozie_web_console_pkg"
include_recipe "cloudera::pig"


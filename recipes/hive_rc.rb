#
# Add Hive to Hadoop cluster
#

include_recipe "cloudera::metastore"
include_recipe "cloudera::hive_client_pkg"

package "hive-jdbc"
package "hive-server"
package "hive-server2"
package "hive-metastore"

package "mysql-connector-java"

link "/usr/lib/hive/lib/mysql-connector-java.jar" do
  to "/usr/share/java/mysql-connector-java.jar"
end


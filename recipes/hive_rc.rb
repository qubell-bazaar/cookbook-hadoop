#
# Add Hive to Hadoop cluster
#

include_recipe "cloudera"
include_recipe "cloudera::cm_repo"
include_recipe "cloudera::metastore"
include_recipe "cloudera::hive_client_pkg"

include_recipe "python::pip"
python_pip "cm_api" do
  version "6.0.2"
  retries 2
  action :install
end

package "hive-jdbc"
package "hive-server"
package "hive-server2"
package "hive-metastore"

package "mysql-connector-java"

link "/usr/lib/hive/lib/mysql-connector-java.jar" do
  to "/usr/share/java/mysql-connector-java.jar"
end


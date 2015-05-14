#
# Add Hive to Hadoop cluster
#


package "hive"
package "hive-jdbc"
package "hive-server"
package "hive-server2"
package "hive-metastore"

cookbook_file "/usr/local/bin/update_postgres.sh" do
  source "update_postgres.sh"
  mode "0755"
end

execute "/usr/local/bin/update_postgres.sh"


include_recipe "mysql::server"
include_recipe "database::mysql"

cookbook_file "/etc/my.cnf" do
  source "my.cnf"
  mode "0644"
end

service "mysqld" do
  action [:restart]
end


mysql_connection_info = {
  :host => "localhost",
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database 'metastore' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'hive' do
  connection mysql_connection_info
  password 'hive'
  database_name 'metastore'
  host 'localhost'
  action :grant
end


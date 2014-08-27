package "unzip"
oozie_path = "/var/lib/oozie"
target_archive =  File.join(oozie_path,"ext-2.2.zip")

remote_file target_archive  do
  source "http://10.15.240.221/web/ext-2.2.zip"
  owner "oozie"
  group "oozie"
end

execute "unzip ext-2.2.zip; ln -s ext-2.2 ext" do
  retries 3
  cwd oozie_path
  user "oozie"
end


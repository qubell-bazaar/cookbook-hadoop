
cookbook_file "/usr/local/bin/oozie.py" do
  source "oozie.py"
  mode "0755"
end

execute "/usr/local/bin/oozie.py #{node.cloudera.manager.host} Default #{node.cloudera.jobtracker.host} #{node.cloudera.master.host}" do
  retries 3
  retry_delay 5
end


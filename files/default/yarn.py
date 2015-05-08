#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180

manager_host = sys.argv[1]
master_host = sys.argv[2]
cluster_name = sys.argv[3]

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

try:
    yarn = cluster.get_service("yarn1")
except ApiException:
    yarn = cluster.create_service("yarn1", "YARN")

try:
    yarn_jobhistory_server = yarn.get_role("yarn_jobhistory1")
except ApiException:
    yarn_jobhistory_server = yarn.create_role("yarn_jobhistory1", "JOBHISTORY", master_host)

try:
    yarn_resource_manager = yarn.get_role("yarn_resource_manager1")
except ApiException:
    yarn_resource_manager = yarn.create_role("yarn_resource_manager1", "RESOURCEMANAGER", manager_host)

for i in xrange(4, len(sys.argv)):
    name = "yarn-nodemanager" + str(i - 3)
    try:
       yarn.get_role(name)
    except ApiException:
       yarn.create_role(name, "NODEMANAGER", sys.argv[i])

yarn_service_config={
    'hdfs_service': 'hdfs1',
    'zookeeper_service': 'zookeeper1',
    
}

yarn.update_config(svc_config=yarn_service_config)

yarn_roletype_config = {
  'JOBHISTORY': {
    'mr2_jobhistory_log_dir': '/opt/log/hadoop-mapreduce'
  },
  'RESOURCEMANAGER': {
    'resource_manager_log_dir': '/opt/log/hadoop-yarn'
  },
  'NODEMANAGER': {
    'node_manager_log_dir': '/opt/log/hadoop-yarn',
    'yarn_nodemanager_local_dirs': '/opt/yarn/nm',
    'yarn_nodemanager_heartbeat_interval_ms': '100',
    'yarn_nodemanager_resource_cpu_vcores': '2',
    'yarn_nodemanager_resource_memory_mb': '1024'
  }
}
for rcg in yarn.get_all_role_config_groups():
  if rcg.roleType in yarn_roletype_config:
    rcg.update_config(yarn_roletype_config[rcg.roleType])

service_roles_names = []
roles_types = yarn.get_role_types()
for role_type in roles_types:
    roles = yarn.get_roles_by_type(role_type)
    for role in roles:
        service_roles_names.append(role.name)

cmd = yarn.deploy_client_config(*service_roles_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy Yarn configuration")


yarn_restart = yarn.restart()

if not yarn_restart.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to restart Yarn")


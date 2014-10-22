#!/usr/bin/env python

import sys
import socket
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(sys.argv[2])

hdfs = cluster.get_service('hdfs1')
hdfs_service_config = {
    'dfs_block_local_path_access_user': 'impala'
}
hdfs_roles_names = []
roles_types = hdfs.get_role_types()
for role_type in roles_types:
    roles = hdfs.get_roles_by_type(role_type)
    for role in roles:
        hdfs_roles_names.append(role.name)

hdfs.update_config(svc_config=hdfs_service_config)

cmd_hdfs = hdfs.deploy_client_config(*hdfs_roles_names)

if not cmd_hdfs.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy HDS client configuration")

cmd_hdfs = hdfs.restart()

try:
    impala = cluster.get_service("impala1")
except ApiException:
    impala = cluster.create_service("impala1", "IMPALA")

try:
    impala.get_role("impala-statestore1")
except ApiException:
    impala.create_role("impala-statestore1", "STATESTORE", sys.argv[3])

try:
    impala.get_role("impala-catalogserver1")
except ApiException:
    impala.create_role("impala-catalogserver1", "CATALOGSERVER", sys.argv[3])


impala_service_config = {
    'hbase_service': 'hbase1',
    'hive_service': 'hive1',
    'hdfs_service': 'hdfs1'
}

impala.update_config(svc_config=impala_service_config)


for i in xrange(4, len(sys.argv)):
    name = "impalad" + str(i - 3)
    print(name)
    try:
        impala.get_role(name)
    except ApiException:
        hostname = socket.gethostbyaddr(sys.argv[i])[0]
        impala.create_role(name, "IMPALAD", hostname)

if not cmd_hdfs.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to reconfigure HDFS")

cmd = impala.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start Impala")

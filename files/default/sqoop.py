#!/usr/bin/env python

import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(sys.argv[2])

try:
    sqoop = cluster.get_service("sqoop1")
except ApiException:
    sqoop = cluster.create_service("sqoop1", "SQOOP")
try:
    sqoop_server = sqoop.get_role("sqoop-server1")
except ApiException:
    sqoop_server = sqoop.create_role("sqoop-server1", "SQOOP_SERVER", sys.argv[3])

sqoop_service_config = {
    'mapreduce_yarn_service': 'mapreduce1'
}

sqoop.update_config(svc_config=sqoop_service_config)

sqoop_roletype_config = {
  'SQOOP_SERVER': {
    'sqoop_log_dir': '/opt/log/sqoop'
  }
}
for rcg in sqoop.get_all_role_config_groups():
  if rcg.roleType in sqoop_roletype_config:
    rcg.update_config(sqoop_roletype_config[rcg.roleType])

cmd = sqoop.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start Sqoop")

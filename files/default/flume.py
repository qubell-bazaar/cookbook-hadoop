#!/usr/bin/env python

import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=3)
cluster = api.get_cluster(sys.argv[2])

try:
    flume = cluster.get_service("flume1")
except ApiException:
    flume = cluster.create_service("flume1", "FLUME")

for i in xrange(3, len(sys.argv)):
    name = "flume-agent" + str(i - 2)
    try:
        flume.get_role(name)
    except ApiException:
        flume.create_role(name, "AGENT", sys.argv[i])

flume_service_config = {
    'hbase_service': 'hbase1',
    'hdfs_service': 'hdfs1'
}


flume.update_config(svc_config=flume_service_config)


cmd = flume.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start Flume")
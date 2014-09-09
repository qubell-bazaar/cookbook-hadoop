#!/usr/bin/env python

import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=3)
cluster = api.get_cluster(sys.argv[2])

try:
    oozie = cluster.get_service("oozie1")
except ApiException:
    raise Exception("Can not find Oozie service")

cmd = oozie.start()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start Oozie")

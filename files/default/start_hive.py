#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180

manager_host = sys.argv[1]
cluster_name = sys.argv[2]

gateway_name = 'hive-gateway1'

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

try:
    hive = cluster.get_service("hive1")
except ApiException:
    raise Exception('Failed to get Hive service')



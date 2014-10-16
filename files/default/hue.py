#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180

manager_host = sys.argv[1]
cluster_name = sys.argv[2]

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

try:
    hue = cluster.get_service("hue1")
except ApiException:
    hue = cluster.create_service("hue1", "HUE")

hue_service_config={
    'hive_service': 'hive1',
    'hbase_service': 'hbase1',
    'hue_hbase_thrift': 'hbasethriftserver1',
    'oozie_service': 'oozie1',
    'impala_service': 'impala1',
    'sqoop_service': 'sqoop1',
    'solr_service': 'solr1',
    'hue_webhdfs': 'hdfs1_NAMENODE_1'
}
hue.update_config(svc_config=hue_service_config)

try:
    hue_server = hue.get_role("hue-server1")
except ApiException:
    hue_server = hue.create_role("hue-server1", "HUE_SERVER", manager_host)

if cluster.version == "CDH4": 
  try:
      beeswax_server = hue.get_role("beeswax-server1")
  except ApiException:
      beeswax_server = hue.create_role("beeswax-server1", "BEESWAX_SERVER", manager_host)


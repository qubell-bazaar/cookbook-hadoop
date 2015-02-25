#!/usr/bin/env python

import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(sys.argv[2])

hbase_service_config = {
    'hbase_enable_indexing': True,
    'hbase_enable_replication': True
}

hbase = cluster.get_service("hbase1")
hbase.update_config(svc_config=hbase_service_config)
service_roles_names = []
roles_types = hbase.get_role_types()
for role_type in roles_types:
    roles = hbase.get_roles_by_type(role_type)
    for role in roles:
        service_roles_names.append(role.name)

hbase.update_config(svc_config=hbase_service_config)

cmd = hbase.deploy_client_config(*service_roles_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy HBASE client configuration")

try:
    ks_indexer = cluster.get_service("ks_indexer1")
except ApiException:
    ks_indexer = cluster.create_service("ks_indexer1", "KS_INDEXER")

for i in xrange(3, len(sys.argv)):
    name = "hbase-indexer" + str(i - 2)
    try:
       ks_indexer.get_role(name)
    except ApiException:
       ks_indexer.create_role(name, "HBASE_INDEXER", sys.argv[i])

ks_indexer_service_config = {
    'hbase_service': 'hbase1',
    'solr_service': 'solr1',
}
ks_indexer.update_config(svc_config=ks_indexer_service_config)

hbase_roletype_config = {
  'HBASE_INDEXER': {
    'hbase_indexer_log_dir': '/opt/log/hbase-solr'
  }
}
for rcg in ks_indexer.get_all_role_config_groups():
  if rcg.roleType in hbase_roletype_config:
    rcg.update_config(hbase_roletype_config[rcg.roleType])

service_roles_names = []
roles_types = ks_indexer.get_role_types()
for role_type in roles_types:
    roles = ks_indexer.get_roles_by_type(role_type)
    for role in roles:
        service_roles_names.append(role.name)

hbase_restart = hbase.restart()
mapreduce_restart = cluster.get_service("mapreduce1").restart()

if not hbase_restart.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to restart HBase")

if not mapreduce_restart.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to restart MapReduce")

cmd = ks_indexer.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start ks_indexer")

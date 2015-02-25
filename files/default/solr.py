#!/usr/bin/env python

import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 300 
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(sys.argv[2])

try:
    solr = cluster.get_service("solr1")
except ApiException:
    solr = cluster.create_service("solr1", "SOLR")


try:
    solr.get_role("solr-gateway1")
except ApiException:
    solr.create_role("solr-gateway1", "GATEWAY", sys.argv[3])

for i in xrange(3, len(sys.argv)):
    name = "solr-server" + str(i - 2)
    try:
        solr.get_role(name)
    except ApiException:
        solr.create_role(name, "SOLR_SERVER", sys.argv[i])

solr_service_config = {
    'hdfs_service': 'hdfs1',
    'zookeeper_service': 'zookeeper1'
}
solr.update_config(svc_config=solr_service_config)

solr_roletype_config = {
  'SOLR_SERVER': {
    'solr_log_dir': '/opt/log/solr'
  }
}
for rcg in solr.get_all_role_config_groups():
  if rcg.roleType in solr_roletype_config:
    rcg.update_config(solr_roletype_config[rcg.roleType])

service_roles_names = []
roles_types = solr.get_role_types()
for role_type in roles_types:
    roles = solr.get_roles_by_type(role_type)
    for role in roles:
        service_roles_names.append(role.name)

cmd = solr.deploy_client_config(*service_roles_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy SOLR client configuration")


if solr.serviceState != 'STARTED':
    cmd = solr._cmd("createSolrHdfsHomeDir")
    if not cmd.wait(CMD_TIMEOUT).success:
      raise Exception("Failed to create Solr HDFS home directory")

    cmd = solr._cmd("initSolr")
    if not cmd.wait(CMD_TIMEOUT).success:
      raise Exception("Failed to init Solr")

cmd = solr.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start Solr")

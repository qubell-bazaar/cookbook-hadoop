#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 880

manager_host = sys.argv[1]
master = sys.argv[2]
data_nodes = sys.argv[3]
cluster_name = sys.argv[4]

metastore_name = 'hive-metastore1'
gateway_name = 'hive-gateway1'
hiveserver_2_name = 'hive-server2'

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)
gateway_hosts = "{0} {1} {2}".format(manager_host, master, data_nodes)

try:
    hive = cluster.get_service("hive1")
except ApiException:
    hive = cluster.create_service("hive1", "HIVE")

hive_service_config = {
    'mapreduce_yarn_service': 'mapreduce1',
    'zookeeper_service': 'zookeeper1',
    'hive_metastore_database_password': 'hive',
    'hive_metastore_database_user': 'hive',
    'hive_metastore_database_type': 'mysql',
    'hive_metastore_database_port': 3306,
    'hive_metastore_database_auto_create_schema': True,
}

if cluster.version == "CDH4":
    hive_service_config['hive_metastore_database_fixed_datastore'] = False

hive.update_config(svc_config=hive_service_config)

try:
    hive.get_role(metastore_name)
except ApiException:
    hive.create_role(metastore_name, 'HIVEMETASTORE', manager_host)
    cmd = hive.create_hive_warehouse()
    if not cmd.wait(CMD_TIMEOUT).success:
        raise Exception('Failed to create Hive warehouse.')

try:
    hive.get_role(hiveserver_2_name)
except ApiException:
    hive.create_role(hiveserver_2_name, 'HIVESERVER2', manager_host)

hive_role_names = []
for host in gateway_hosts.split(' '):
    role_name = "{0}_{1}".format(gateway_name, host.split('.')[0]).replace('-', '_')
    try:
        hive.get_role(role_name)
    except ApiException:
        hive.create_role(role_name, 'GATEWAY', host)
    hive_role_names.append(role_name)

cmd = hive.deploy_client_config(*hive_role_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy client configuration")

if cluster.version == "CHD5":
    cmd = hive.create_hive_metastore_tables()
    if not cmd.wait(CMD_TIMEOUT).success:
        raise Exception("Failed to create tables")

cmd = hive.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception('Failed to start the Hive service.')

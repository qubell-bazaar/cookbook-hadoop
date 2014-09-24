#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 1380

manager_host = sys.argv[1]
master = sys.argv[2]
region_servers = sys.argv[3]
cluster_name = sys.argv[4]

gateway_name = 'hbase-gateway1'
region_name = 'hbase-region'

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=3)
cluster = api.get_cluster(cluster_name)
gateway_hosts = "{0} {1} {2}".format(manager_host, master, region_servers)

try:
    hbase = cluster.get_service("hbase1")
except ApiException:
    hbase = cluster.create_service("hbase1", "HBASE")

hbase_service_config = {
    'zookeeper_service': 'zookeeper1',
    'hdfs_service': 'hdfs1'
}
hbase.update_config(svc_config=hbase_service_config)
try:
    hbase.get_role('master')
except ApiException:
    hbase.create_role('master', 'MASTER', master)

hbase_regionserver_role_config = {
    'hbase_hregion_max_filesize': '21474836480',
    'hbase_regionserver_handler_count': '40',
    'hbase_hstore_blockingStoreFiles': '15',
    'hbase_regionserver_codecs': 'snappy',
    'hbase_regionserver_java_opts': (
        '-XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:-CMSConcurrentMTEnabled'
        ' -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled'
        ' -Xloggc:/var/log/hbase/gc-output.log -XX:+PrintGC -XX:+PrintGCDetails'
        ' -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps'
    ),
    'hbase_regionserver_config_safety_valve': (
        '<property>'
        '<name>hbase.regionserver.hlog.blocksize</name>'
        '<value>268435456</value>'
        '</property>'
        '<property>'
        '<name>hbase.regionserver.maxlogs</name>'
        '<value>64</value>'
        '</property>'
    )
}
hbase_role_names = []
for host in region_servers.split(' '):
    role_name = "{0}_{1}".format(region_name, host.split('.')[0]).replace('-', '_')
    try:
        role = hbase.get_role(role_name)
    except ApiException:
        role = hbase.create_role(role_name, 'REGIONSERVER', host)

        # TODO! Find a way to update config for all instances.
    role.update_config(hbase_regionserver_role_config)
    hbase_role_names.append(role_name)

for host in gateway_hosts.split(" "):
    role_name = "{0}_{1}".format(gateway_name, host.split(".")[0]).replace("-", "_")
    try:
        hbase.get_role(role_name)
    except ApiException:
        hbase.create_role(role_name, "GATEWAY", host)
    hbase_role_names.append(role_name)

try:
    hbase.get_role("hbasethriftserver1")

except ApiException:
    hbase.create_role("hbasethriftserver1", "HBASETHRIFTSERVER", master)

hbase_role_names.append("hbasethriftserver1")

cmd = hbase.deploy_client_config(*hbase_role_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy client configuration")


cmd = hbase.stop()
cmd.wait(CMD_TIMEOUT)
cmd = hbase.start()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to start the Hbase service.")

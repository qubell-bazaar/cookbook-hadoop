#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180

manager_host = sys.argv[1]
master_host = sys.argv[2]
cluster_name = sys.argv[3]

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

try:
    spark = cluster.get_service("spark_on_yarn1")
except ApiException:
    spark = cluster.create_service("spark_on_yarn1", "SPARK_ON_YARN")

try:
    spark_history_server = spark.get_role("spark_history1")
except ApiException:
    spark_history_server = spark.create_role("spark_history1", "SPARK_YARN_HISTORY_SERVER", master_host)

for i in xrange(4, len(sys.argv)):
    name = "spark-gateway" + str(i - 3)
    try:
       spark.get_role(name)
    except ApiException:
       spark.create_role(name, "GATEWAY", sys.argv[i])

spark_service_config={
    'yarn_service': 'yarn1'
}

spark.update_config(svc_config=spark_service_config)

spark_roletype_config = {
  'SPARK_YARN_HISTORY_SERVER': {
    'log_dir': '/opt/log/spark'
  }
}
for rcg in spark.get_all_role_config_groups():
  if rcg.roleType in spark_roletype_config:
    rcg.update_config(spark_roletype_config[rcg.roleType])

service_roles_names = []
roles_types = spark.get_role_types()
for role_type in roles_types:
    roles = spark.get_roles_by_type(role_type)
    for role in roles:
        service_roles_names.append(role.name)

cmd = spark.deploy_client_config(*service_roles_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy Spark configuration")

spark_restart = spark.restart()
if not spark_restart.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to restart Spark")


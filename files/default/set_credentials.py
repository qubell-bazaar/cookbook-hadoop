#!/usr/bin/env python

import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 180
api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=3)
cluster = api.get_cluster(sys.argv[2])

hdfs = cluster.get_service("hdfs1")

hdfs_service_config = {
    'core_site_safety_valve': ("<property>\n"
                               "  <name>fs.s3.awsAccessKeyId</name>\n"
                               "  <value>{0}</value>\n"
                               "</property>\n"
                               "<property>\n"
                               "  <name>fs.s3.awsSecretAccessKey</name>\n"
                               "  <value>{1}</value>\n"
                               "</property>\n"
                               "<property>\n"
                               "  <name>fs.s3n.awsAccessKeyId</name>\n"
                               "  <value>{0}</value>\n"
                               "</property>\n"
                               "<property>\n"
                               "  <name>fs.s3n.awsSecretAccessKey</name>\n"
                               "  <value>{1}</value>\n"
                               "</property>\n").format(sys.argv[3], sys.argv[4])
}

hdfs.update_config(svc_config=hdfs_service_config)

hdfs_roles_names = []
roles_types = hdfs.get_role_types()
for role_type in roles_types:
    roles = hdfs.get_roles_by_type(role_type)
    for role in roles:
        hdfs_roles_names.append(role.name)

hdfs.update_config(svc_config=hdfs_service_config)

cmd = hdfs.deploy_client_config(*hdfs_roles_names)

if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to deploy HDFS client configuration")

cmd = hdfs.restart()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to restart HDFS")

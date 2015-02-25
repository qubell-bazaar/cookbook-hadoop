#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource

CMD_TIMEOUT = 180

manager_host = sys.argv[1]
cluster_name = sys.argv[2]
action = sys.argv[3]

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

if action == "format":
    hdfs = cluster.get_service("hdfs1")
    cmd = hdfs.format_hdfs("hdfs1_NAMENODE_1")[0]
    if not cmd.wait(CMD_TIMEOUT).success:
        raise Exception("Failed to format HDFS")
elif action == "start":
    service_name = sys.argv[4]
    service = cluster.get_service(service_name)
    if service_name == "hdfs1" or service_name == "mapreduce1": ## TODO! Refactoring is needed
        service_config = {}
        if service_name == "hdfs1":
            # TODO: HACK!! disable dfs permissions
            service_config = {
                'dfs_permissions': False
            }
        if service_name == "mapreduce1":
            service_config = {
                'mapreduce_service_config_safety_valve': (
                    '<property>'
                    '<name>mapreduce.tasktracker.cache.local.size</name>'
                    '<value>2294967296</value>'
                    '</property>'
                    '<property>'
                    '<name>jobtracker.thrift.address</name>'
                    '<value>0.0.0.0:9290</value>'
                    '</property>'
                    '<property>'
                    '<name>mapred.jobtracker.plugins</name>'
                    '<value>org.apache.hadoop.thriftfs.ThriftJobTrackerPlugin</value>'
                    '<description>Comma-separated list of jobtracker plug-ins to be activated.'
                    '</description>'
                    '</property>'

            )
            }
        service_roles_names = []
        roles_types = service.get_role_types()
        for role_type in roles_types:
            roles = service.get_roles_by_type(role_type)
            for role in roles:
                service_roles_names.append(role.name)
        service.update_config(svc_config=service_config)

        hdfs_roletype_config = {
          'NAMENODE': {
            'namenode_log_dir': '/opt/log/hadoop-hdfs'
          },
          'DATANODE': {
            'datanode_log_dir': '/opt/log/hadoop-hdfs'
          },
          'SECONDARYNAMENODE': {
            'secondarynamenode_log_dir': '/opt/log/hadoop-hdfs'
          }
        }
        mr_roletype_config = {
          'TASKTRACKER':{
            'tasktracker_log_dir': '/opt/log/hadoop-0.20-mapreduce'
          },
          'JOBTRACKER':{
            'jobtracker_log_dir': '/opt/log/hadoop-0.20-mapreduce'
          }
        }
        for rcg in service.get_all_role_config_groups():
          if rcg.roleType in hdfs_roletype_config:
            rcg.update_config(hdfs_roletype_config[rcg.roleType])
          if rcg.roleType in mr_roletype_config:
            rcg.update_config(mr_roletype_config[rcg.roleType])

        cmd = service.deploy_client_config(*service_roles_names)
        if not cmd.wait(CMD_TIMEOUT).success:
            raise Exception("Failed to deploy client config for %s" % service_name)

    cmd = service.restart()
    if not cmd.wait(CMD_TIMEOUT).success:
        raise Exception("Failed to start %s" % service_name)

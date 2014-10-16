#!/usr/bin/env python

import sys
import time
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException

CMD_TIMEOUT = 380
manager_host = sys.argv[1]
cluster_name = sys.argv[2]
jobtracker = sys.argv[3]
namenode = sys.argv[4]

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

try:
    oozie = cluster.get_service("oozie1")
except ApiException:
    oozie = cluster.create_service("oozie1", "OOZIE")

try:
    oozie_server = oozie.get_role("oozie-server1")
except ApiException:
    oozie_server = oozie.create_role("oozie-server1", "OOZIE_SERVER", manager_host)

oozie_service_config = {
    'mapreduce_yarn_service': 'mapreduce1'
}

oozie.update_config(svc_config=oozie_service_config)

oozie_server_config = {
    'oozie_config_safety_valve': '<property>'
                                 '<name>oozie.service.HadoopAccessorService.nameNode.whitelist</name>'
                                 '<value>{0}:8020</value>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.HadoopAccessorService.jobTracker.whitelist</name>'
                                 '<value>{1}:8021</value>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.PurgeService.older.than</name>'
                                 '<value>30</value>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.PurgeService.coord.older.than</name>'
                                 '<value>7</value>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.PurgeService.bundle.older.than</name>'
                                 '<value>7</value>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.PurgeService.purge.limit</name>'
                                 '<value>1000</value>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.PurgeService.purge.interval</name>'
                                 '<value>7200</value>'
                                 '<description>Default is 3600 seconds, and purge tasks get accumulating in the task queue, possibly impacting other tasks like state transition ones. Trying to run fewer purge tasks with larger limit (1000 against default of 100).</description>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.SchedulerService.threads</name>'
                                 '<value>10</value>'
                                 '<description>Twice as default.</description>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.CallableQueueService.queue.size</name>'
                                 '<value>10000</value>'
                                 '<description>Default value.</description>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.CallableQueueService.threads</name>'
                                 '<value>20</value>'
                                 '<description>Twice as default.</description>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.CallableQueueService.callable.concurrency</name>'
                                 '<value>5</value>'
                                 '<description>Default is 3.</description>'
                                 '</property>'
                                 '<property>'
                                 '<name>oozie.service.PurgeService.coord.action.older.than</name>'
                                 '<value>3</value>'
                                 '<description>Custom Purge Service needs that (the prefix is correct, though).</description>'
                                 '</property>'.format(namenode, jobtracker),
    'oozie_web_console': 'true'
}

oozie_server.update_config(oozie_server_config)

if oozie.serviceState == 'STARTED':
    cmd = oozie.stop()
    if not cmd.wait(CMD_TIMEOUT).success:
        raise Exception("Can't stop Oozie")

counter = 0
while counter < 10:
    counter += 1
    time.sleep(10)
    cmd = oozie.install_oozie_sharelib()
    if cmd.wait(CMD_TIMEOUT).success:
        break
else:
    raise Exception("Can't install Oozie ShareLib")

cmd = oozie.create_oozie_db()
if not cmd.wait(CMD_TIMEOUT).success:
    raise Exception("Failed to create Oozie tables")

# is it needed?
# cmd = cluster.deploy_client_config()
#if not cmd.wait(CMD_TIMEOUT).success:
#   raise Exception("Failed to deploy client configuration")


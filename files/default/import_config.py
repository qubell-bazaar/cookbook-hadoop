#!/usr/bin/env python
import sys
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException
from boto.s3.connection import S3Connection
from boto.s3.key import Key

CMD_TIMEOUT = 600

manager_host = sys.argv[1]
cluster_name = sys.argv[2]
awsAccessId = sys.argv[3]
awsSecretKey = sys.argv[4]
importBucket = sys.argv[5]
importKey = sys.argv[6]

# retrieve cluster configuration

conn = S3Connection(awsAccessId, awsSecretKey)
bucket = conn.get_bucket(importBucket)

k = Key(bucket)
k.key = importKey
cluster_config = k.get_contents_as_string()

# deploy retrieved configuration to cluster

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=4)
cluster = api.get_cluster(cluster_name)

cmd = cluster.stop()
if not cmd.wait(CMD_TIMEOUT).success:
  raise Exception("Failed to stop cluster")

api.put('cm/deployment', params={'deleteCurrentDeployment': True}, data=cluster_config)

cmd = cluster.start()
if not cmd.wait(CMD_TIMEOUT).success:
  raise Exception("Failed to start cluster")


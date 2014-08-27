#!/usr/bin/env python
import sys
import json
from cm_api.api_client import ApiResource
from cm_api.api_client import ApiException
from boto.s3.connection import S3Connection
from boto.s3.key import Key

CMD_TIMEOUT = 180

manager_host = sys.argv[1]
awsAccessId = sys.argv[2]
awsSecretKey = sys.argv[3]
exportBucket = sys.argv[4]
exportKey = sys.argv[5]

# retrieve cluster configuration

api = ApiResource(manager_host, username="admin", password="admin", use_tls=False, version=3)

cluster_config = api.get('cm/deployment')

# store retrieved configuration to s3

conn = S3Connection(awsAccessId, awsSecretKey)
bucket = conn.get_bucket(exportBucket)

k = Key(bucket)
k.key = exportKey
k.set_contents_from_string(json.dumps(cluster_config))

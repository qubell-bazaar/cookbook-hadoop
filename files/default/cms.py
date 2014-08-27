#!/usr/bin/env python
# TO DELETE
import sys
from cm_api.api_client import ApiResource
from cm_api.endpoints.types import *
from cm_api.endpoints.services import ApiServiceSetupInfo
from cm_api.endpoints.roles import ApiRole

import socket

CMD_TIMEOUT = 180
ROLE_TYPES = [
  "SERVICEMONITOR",
  "ACTIVITYMONITOR",
  "HOSTMONITOR",
  "EVENTSERVER",
  "ALERTPUBLISHER"
]

creds = {}

# Load credentials from CM configuration
# FIXME: could be removed in future version?
f = file('/etc/cloudera-scm-server/db.mgmt.properties')
for line in f:
  if not line.startswith("#"):
    (key, value) = line.split("=")
    s = key.split('.')
    service = s[3].strip()
    setting = s[5].strip()
    value = value.strip()
    if service not in creds:
      creds[service] = {}
    creds[service][setting] = value


api = ApiResource(sys.argv[1], username="admin", password="admin", use_tls=False, version=3)
cm = api.get_cloudera_manager()

roles = [ApiRole(api, t.lower(), t, ApiHostRef(api, sys.argv[1])) for t in ROLE_TYPES]
mgmt = ApiServiceSetupInfo("management", "MGMT", roles=roles)
service = cm.create_mgmt_service(mgmt)

rcg = service.get_all_role_config_groups()
for rc in rcg:
  if rc.roleType in creds and rc.roleType in ROLE_TYPES:
    config = {}
    for (k,v) in creds[rc.roleType].iteritems():
      config["firehose_database_" + k] = v
    # Reduce amount of some logs to 1 day
    if rc.roleType == "ACTIVITYMONITOR":
        config["firehose_activity_purge_duration_hours"] = "24"
        config["firehose_attempt_purge_duration_hours"] = "24"
    config["timeseries_expiration_hours"] = "24"
    rc.update_config(config)

cmd = service.start()

if not cmd.wait(CMD_TIMEOUT).success:
  raise Exception("Failed to start Management Services")

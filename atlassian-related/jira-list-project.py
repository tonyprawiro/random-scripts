#!/usr/bin/env python

import requests
import json
import os

r = requests.get("https://www.domain.com/jira/rest/api/latest/project?limit=200", auth=(os.environ['JIRA_ADMIN_USERNAME'], os.environ['JIRA_ADMIN_PASSWORD']))

if r.status_code == 200:

    result = json.loads(r.text)

    for project in result:

        print "%20s %s" % (project['key'], project['name'])

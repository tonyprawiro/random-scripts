#!/usr/bin/env python

import requests
import json
import os

r = requests.get("https://www.domain.com/stash/rest/api/1.0/projects?limit=200", auth=(os.environ['BITBUCKET_ADMIN_USERNAME'], os.environ['BITBUCKET_ADMIN_PASSWORD']))

if r.status_code == 200:

    result = json.loads(r.text)

    for project in result['values']:

        print "%20s %s" % (project['key'], project['name'])

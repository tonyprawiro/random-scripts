#!/usr/bin/env python

import requests
import json
import os

r = requests.get("https://www.domain.com/confluence/rest/api/space?limit=200", auth=(os.environ['CONFLUENCE_ADMIN_USERNAME'], os.environ['CONFLUENCE_ADMIN_PASSWORD']))

if r.status_code == 200:

    result = json.loads(r.text)

    for space in result['results']:

        if space['key'][0]!='~':

            print "%20s %s" % (space['key'], space['name'])

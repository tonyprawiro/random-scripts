#!/usr/bin/env python

import xmlrpclib
import os
import sys
import json

try:
    confluence_url = os.environ['CONFLUENCE_URL']
    confluence_username = os.environ['CONFLUENCE_USERNAME']
    confluence_password = os.environ['CONFLUENCE_PASSWORD']
except:
    print "Environment variables required:"
    print "CONFLUENCE_URL"
    print "CONFLUENCE_USERNAME"
    print "CONFLUENCE_PASSWORD"
    sys.exit(1)

proxy = xmlrpclib.ServerProxy("%s/rpc/xmlrpc" % confluence_url)

tk = proxy.confluence2.login(confluence_username, confluence_password)

spaces = proxy.confluence2.getSpaces(tk)

result = {}

for space in spaces:

    if space['key'][0] != '~':

        permissions = proxy.confluence2.getSpacePermissionSets(tk, space['key'])

        result[space['key']] = {
            "key": space["key"],
            "name": space["name"],
            "permissions": permissions
        }

print json.dumps(result)

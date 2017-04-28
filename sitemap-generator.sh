#!/bin/bash

if [ -z $1 ] ; then
  BASE="/var/www/html"
else
  BASE=$1
fi

if [ -z $2 ] ; then
  SERVER="http://domain.com"
else
  SERVER=$2
fi

if [ -z $3 ] ; then
  SITEMAP="${BASE}/sitemap.txt"
else
  SITEMAP="${BASE}/$3"
fi

cd $BASE

echo "$SERVER" > $SITEMAP

( find . -name "*" \
  | grep -v "^.$" \
  | grep -v "^.\/_" \
  | grep -v \.gif$ \
  | grep -v \.png$ \
  | grep -v \.jpg$ \
  | grep -v \.jpeg$ \
  | grep -v \.css$ \
  | grep -v \.scss$ \
  | grep -v \.js$ \
  | grep -v ^\./rss \
  | grep -v ^\./cgi-bin \
  | sed 's/^\.\///g'
  ) | while read fname; do
    echo "${SERVER}/${fname}" >> $SITEMAP
  done

cd - > /dev/null

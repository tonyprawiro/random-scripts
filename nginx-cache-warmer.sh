#!/bin/bash

set -m # Enable Job Control

# if [ -z $1 ] ; then
#   SERVER="http://domain.com"
# else
#   SERVER=$1
# fi
#
# if [ -z $2 ] ; then
#   SITEMAP="sitemap.txt"
# else
#   SITEMAP=$2
# fi
#
# if [ -z $3 ] ; then
#   DELAY="1"
# else
#   DELAY=$3
# fi

BASE="/opt/cache-warmer"
if [ ! -f $BASE ]; then
  BASE="./"
fi
SERVER="http://domain.com"
ADDRESS="52.12.34.56"
SITEMAP="sitemap.txt"
DELAY=1
SPLIT=5
while [[ $# > 0 ]]; do
  key="$1"
  case $key in
    -b|--basedir)
    BASE="$2"
    shift
    ;;
    -s|--sitemap)
    SITEMAP="$2"
    shift
    ;;
    -d|--delay)
    DELAY="$2"
    shift
    ;;
    -c|--chunks)
    SPLIT="$2"
    shift
    ;;
    -a|--address)
    ADDRESS="$2"
    shift
    ;;
    #--default)
    #DEFAULT=YES
    #;;
    *)
    SERVER="$1"
    ;;
  esac
  shift # past argument or value
done

DOMAIN=$(echo $SERVER | awk -F/ '{print $3}')

# Change directory
mkdir "${BASE}/${DOMAIN}" > /dev/null 2>&1
cd "${BASE}/${DOMAIN}"

# Remove any existing files
rm sitemap.txt > /dev/null 2>&1
rm x* > /dev/null 2>&1

# Retrieve the sitemap
/usr/bin/curl -s "${SERVER}/${SITEMAP}" -o sitemap.txt

if [ ! -f "sitemap.txt" ]; then
  echo "Failed to retrieve sitemap"
  exit 1
fi

# Get the number of lines for splitting
LINES=$(cat sitemap.txt | wc -l)
SIZE=$(echo "${LINES}/${SPLIT}" | bc)

# Split the sitemap into pieces
split -l $SIZE sitemap.txt

# This is the function that will be forked
function process_chunk(){
  FCHUNK=${1}
  LIMITDOMAIN=${2}
  SDELAY=${3}
  while read LINE; do
    TESTDOMAIN=$(echo $LINE | awk -F/ '{print $3}')
    if [[ "$LIMITDOMAIN" == "$TESTDOMAIN" ]]; then
      echo $LINE
      curl -L -s $LINE > /dev/null
      sleep $SDELAY
    fi
  done < $FCHUNK
}

# Make sure to kill all processes when script exits
trap 'kill $(jobs -p)' EXIT

# Iterate all split files
for XFILE in x*; do
  process_chunk "$XFILE" "$DOMAIN" "$DELAY" &
done

# Wait for all parallel jobs to finish
while [ 1 ]; do fg 2> /dev/null; [ $? == 1 ] && break; done

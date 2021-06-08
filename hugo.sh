#!/usr/bin/bash

(( EUID == 0 )) &&
  { echo >&2 "This script should not be run as root!"; exit 1; }

_hugo() {
  hugo=$( command -v hugo )
  echo "${hugo}"
}

_year() {
  year=$( date -u '+%Y' )
  echo "${year}"
}

_month() {
  month=$( date -u '+%m' )
  echo "${month}"
}

_timestamp() {
  timestamp=$( date -u '+%s%N' | cut -b1-13 )
  echo "${timestamp}"
}

run() {
  cache=$( pwd )
  echo "$( _hugo )" --minify --i18n-warnings --cacheDir "${cache}/cache"
}

server() {
  $( run ) server -D
}

watch() {
  $( run ) -w
}

new_post() {
  $( _hugo ) new posts/"$( _year )"/"$( _month )"/"$( _timestamp )"
}

"$@"

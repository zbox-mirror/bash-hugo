#!/usr/bin/bash

(( EUID == 0 )) &&
  { echo >&2 "This script should not be run as root!"; exit 1; }

_hugo() {
  command -v hugo
}

_year() {
  date -u '+%Y'
}

_month() {
  date -u '+%m'
}

_timestamp() {
  date -u '+%s%N' | cut -b1-13
}

run() {
  cache="$( pwd )"
  echo "$( _hugo )" --i18n-warnings --cacheDir "${cache}/cache"
}

server() {
  $( run ) server -D
}

watch() {
  $( run ) -w
}

new() {
  type="${1}"
  if [[ ${type} == "posts" ]]; then
    $( _hugo ) new "${type}/$( _year )/$( _month )/$( _timestamp )"
  else
    $( _hugo ) new "${type}/$( _timestamp )"
  fi
}

"$@"

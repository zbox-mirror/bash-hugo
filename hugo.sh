#!/usr/bin/bash

(( EUID == 0 )) &&
  { echo >&2 "This script should not be run as root!"; exit 1; }

_cmd_screen() {
  command -v screen
}

_cmd_hugo() {
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

_hugo() {
  cache="$( pwd )"
  screen="app.hugo"
  echo "$( _cmd_screen )" -fn -dmS "${screen}" "$( _cmd_hugo )" --i18n-warnings --cacheDir "${cache}/cache"
}

run() {
  eval "$( _hugo )"
}

server() {
  eval "$( _hugo ) server -D"
}

watch() {
  eval "$( _hugo ) -w"
}

new() {
  type="${1}"
  path="${2}"
  if [[ ${type} == "posts" ]]; then
    $( _cmd_hugo ) new "${type}/$( _year )/$( _month )/$( _timestamp )"
  else
    $( _cmd_hugo ) new "${type}/${path}/$( _timestamp )"
  fi
}

"$@"

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
  echo "$( _cmd_hugo )" --i18n-warnings --cacheDir "${cache}/cache"
}

run() {
  eval "$( _hugo "$@" )"
}

server() {
  local OPTIND=1

  while getopts "p:h" opt; do
    case ${opt} in
      p)
        local port="${OPTARG}";
        ;;
      h|*)
        echo "-p '1313'"
        exit 2
        ;;
    esac
  done

  shift $(( OPTIND - 1 ))

  eval "$( _hugo "$@" ) server -D -p ${port}"
}

watch() {
  eval "$( _hugo "$@" ) -w"
}

new() {
  local OPTIND=1

  while getopts "t:h" opt; do
    case ${opt} in
      t)
        local type="${OPTARG}";
        ;;
      h|*)
        echo "-t ['posts' | '...']"
        exit 2
        ;;
    esac
  done

  shift $(( OPTIND - 1 ))

  if [[ ${type} == "posts" ]]; then
    $( _cmd_hugo ) new "${type}/$( _year )/$( _month )/$( _timestamp )"
  else
    $( _cmd_hugo ) new "${type}/$( _timestamp )"
  fi
}

"$@"

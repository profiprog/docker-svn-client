#!/bin/sh

#echo "GID=$GID ($(id -g)) UID=$UID ($(id -u))"
if ! [ -z "$GID" -a -z "$UID" ] && [ "$(id -g)" -ne "$GID" -o "$(id -u)" -ne "$UID" ]; then
  GROUP="$(getent group "$GID" | awk -F: '{print$1}')"
  if [ -z "$GROUP" ]; then addgroup -g "$GID" user || exit; fi
  adduser -h /home/user -s /bin/sh -G "${GROUP:-user}" -S -D -u "$UID" user
  exec su user -- "$0" "$@"
fi

_contains() {
  local arg="$1"; shift
  while [ $# -gt 0 ]; do [ "$1" == "$arg" ] && return 0; shift; done
  return 1
}

_is_svn_command() { _contains "$1" "add" "auth" "blame" "praise" "annotate" "ann" \
  "cat" "changelist" "cl" "checkout" "co" "cleanup" "commit" "ci" "copy" "cp" \
  "delete" "del" "remove" "rm" "diff" "di" "export" "help" "?" "h" "import" "info" \
  "list" "ls" "lock" "log" "merge" "mergeinfo" "mkdir" "move" "mv" "rename" "ren" \
  "patch" "propdel" "pdel" "pd" "propedit" "pedit" "pe" "propget" "pget" "pg" \
  "proplist" "plist" "pl" "propset" "pset" "ps" "relocate" "resolve" "resolved" \
  "revert" "status" "stat" "st" "switch" "sw" "unlock" "update" "up" "upgrade"; }


if [ "${1:0:1}" == "-" ] || _is_svn_command "$1"; then set -- svn "$@"; fi

if [ "$1" == "svn" ] && ! [ -z "$SVN_USERNAME" -a -z "$SVN_PASSWORD" ]; then
  shift
  set -- --no-auth-cache "$@"
  [ "$SVN_USERNAME" ] && ! _contains --username "$@" && set -- --username "$SVN_USERNAME" "$@"
  [ "$SVN_PASSWORD" ] && ! _contains --password "$@" && set -- --password "$SVN_PASSWORD" "$@"
fi

exec "$@"

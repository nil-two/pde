#!/usr/bin/env bash
set -eu
readonly NAME="$(basename $0)"
readonly VERSION='v0.1.0'

function main() {
  parse_flags $*
  execute_processing
}
function parse_flags() {
  for arg in "$@"; do
    case "$arg" in
      -h|--help)
        usage
        exit 0
        ;;
      -v|--version)
        version
        exit 0
        ;;
      -*)
        echo "$NAME: unrecognized option '$1'"
        exit 2
        ;;
      *)
        break
        ;;
    esac
  done
  if [ "$#" -lt 1 ]; then
    echo "$NAME: no input files"
    exit 2
  fi
  if [ ! -f "$1" ]; then
    echo "$NAME: $1: No such file"
    exit 2
  fi
  SRC="$1"
}
function usage() {
  cat <<EOF
Usage: $NAME [OPTION]... SRC
Execute processing program quickly.

Options:
  -h, --help      display this help text and exit
  -v, --version   display version information and exit
EOF
}
function version() {
  echo "$VERSION"
}
function execute_processing() {
  readonly workdir=$(mktemp --directory "/tmp/${NAME}.tmp.XXXXXX")
  trap "rm -rf '$workdir'" EXIT

  mkdir "$workdir/sketch"
  mkdir "$workdir/output"
  cp "$SRC" "$workdir/sketch/sketch.pde"
  processing-java \
    --run \
    --force \
    --sketch="$workdir/sketch" \
    --output="$workdir/output"
}

main $*
exit 0

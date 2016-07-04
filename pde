#!/bin/sh
set -eu
version="0.1.1"

usage() {
  cat <<__USAGE__ >&2
Usage: ${0##*/} [OPTION]... SRC
Execute processing program quickly.

Options:
  -h, --help      display this help text and exit
  -v, --version   output version information and exit
__USAGE__
}

version() {
  printf "%s\n" "$version" >&2
}

warn() {
  printf "%s: %s\n" "${0##*/}" "$*" >&2
}

while [ $# -gt 0 ]; do
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -v|--version)
      version
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      warn "unrecognized option '$1'"
      exit 2
      ;;
    *)
      break
      ;;
  esac
  shift
done
if [ $# -lt 1 ]; then
  warn "no input file"
  exit 2
fi
if [ ! -f "$1" ]; then
  warn "$1: no such file"
  exit 2
fi

src=$1
workdir=$(mktemp -d "/tmp/${0##*/}.tmp.XXXXXX")
atexit() {
  rm -rf -- "$workdir"
}
trap "atexit" EXIT
trap "trap - EXIT; atexit; exit -1" INT PIPE TERM

mkdir -- "$workdir/sketch"
mkdir -- "$workdir/output"
cp -- "$src" "$workdir/sketch/sketch.pde"
processing-java \
  --sketch="$workdir/sketch" \
  --output="$workdir/output" \
  --force \
  --run

exit 0

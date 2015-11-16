#! /bin/sh
set -eu
readonly version='0.1.0'

usage() {
  cat <<__USAGE__ >&2
Usage: ${0##*/} [OPTION]... SRC
Execute processing program quickly.

Options:
  -h, --help      display this help text and exit
  -v, --version   display version information and exit
__USAGE__
}

version() {
  echo "$version" >&2
}

while [ "$#" -gt 1 ]; do
  case "$1" in
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
      echo "${0##*/}: unrecognized option '$1'" >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
  shift
done
if [ "$#" -lt 1 ]; then
  echo "${0##*/}: no input files" >&2
  exit 2
fi
if [ ! -f "$1" ]; then
  echo "${0##*/}: $1: No such file" >&2
  exit 2
fi

src="$1"
workdir="$(mktemp -d "/tmp/${0##*/}.tmp.XXXXXX")"
atexit() {
  rm -f -- "$workdir"
}
trap 'atexit' EXIT
trap 'trap - EXIT; atexit; exit -1' INT PIPE TERM

mkdir -- "$workdir/sketch"
mkdir -- "$workdir/output"
cp -- "$src" "$workdir/sketch/sketch.pde"
processing-java \
  --sketch="$workdir/sketch" \
  --output="$workdir/output" \
  --force \
  --run

exit 0

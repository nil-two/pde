#! /bin/sh
set -eu
readonly NAME="${0##*/}"
readonly VERSION='v0.1.0'

main() {
  parse_flags $*
  execute_processing
}

parse_flags() {
  for opt in "$@"; do
    case "$opt" in
      -h|--help)
        usage
        exit 0
        ;;
      -v|--version)
        version
        exit 0
        ;;
      -*)
        echo "$NAME: unrecognized option '$opt'"
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

usage() {
  cat <<EOF
Usage: $NAME [OPTION]... SRC
Execute processing program quickly.

Options:
  -h, --help      display this help text and exit
  -v, --version   display version information and exit
EOF
}

version() {
  echo "$VERSION"
}

execute_processing() {
  WORKDIR=$(mktemp --directory "/tmp/${NAME}.tmp.XXXXXX")
  trap "rm -rf '$WORKDIR'" EXIT

  mkdir "$WORKDIR/sketch"
  mkdir "$WORKDIR/output"
  cp "$SRC" "$WORKDIR/sketch/sketch.pde"
  processing-java \
    --sketch="$WORKDIR/sketch" \
    --output="$WORKDIR/output" \
    --force \
    --run
}

main $*
exit 0

#!/bin/bash
# vi: syntax=sh ts=4 expandtab

set -e
# variables
#DYNO_PATH=""
DIR="$DYNO_PATH/dynos"

# functions
errcho() {
    >&2 echo "$*" 
    exit 1
}

_check() {
    which "$1" || errcho "Missing dependency: $1"
}

_hash() {
    $md5 <<< "$*" | cut -d' ' -f1
}

# search through list and kill entries with $die < $now
_prune() {
    echo "Pruning!"
}

# build basic html li list into index.html
_build() {
    echo "Compile!"
}

_store() {
    hash=$1
    shift
    mkdir -p "$DIR"
    echo "$*" > "$DIR/$hash"
}

_list() {
    echo "$1 $2 $3" >> "$DYNO_PATH/dyno.list"
}

# deps
md5=$(_check md5sum)
date=$(_check gdate)
edit=$(which $EDITOR || errcho 'Missing variable: $EDITOR')

# arguments and logic
now=$($date +%s)
case $# in
    0)
        _build
        ;;
    1)
        # if [ ${#1} == 10 ]; then echo "die=$1"; fi
        [ ${#1} == 10 ] && _prune "$1"
        [ ${#1} == 32 ] && $edit "$DIR/$1"
        ;;
    *)
        # default to die in +5 years
        die=$($date -d '+5 year' "+%s")
        content="$*"
        hash=$(_hash "$content")
        _list "$now" "$die" "$hash"
        _store "$hash" "$content"
        ;;
esac

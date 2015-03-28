#!/bin/bash
# vi: syntax=sh ts=4 expandtab

# variables
#DYNO_PATH=""

# functions
_check() {
    which "$1" || echo "Missing dependency: $1" && exit 1
}

_hash() {
    $md5 <<< "$*" | $awk '{print $1}'
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
    dir="$DYNO_PATH/dynos"
    shift
    mkdir -p "$dir"
    echo "$*" > "$dir/$hash"
}

_list() {
    echo "$1 $2 $3" >> "$DYNO_PATH/dyno.list"
}

# deps
md5=$(_check md5sum)
awk=$(_check awk)

# arguments and logic
now=$(date +%s)
case $# in
    0)
        _prune
        _build
        ;;
    1)
        # check if hash or time, else ignore?
        return
        ;;
    *)
        # +5 years
        die=1584729329
        content="$*"
        hash=$(_hash $content)
        _list $now $die $hash
        _store $hash $content
        ;;
esac

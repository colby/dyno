#!/bin/bash
# vi: syntax=sh ts=4 expandtab

# options
dyno_path="/Users/colbyolson/src/dyno"

# functions
check_for() {
    which "$1" || echo "Missing dependency: $1" && exit 1
}

hash_it() {
    $md5 <<< "$*" | $awk '{print $1}'
}

build_it() {
    echo "Compile!"
}

store_it() {
    local content="$*"
    local hash=$(hash_it "$content")
    mkdir -p "$dyno_path/dynos"
    echo "$content" > "$dyno_path/dynos/$hash"
    list_it $(date +%s) $hash
}

list_it() {
    echo "$1 $2" >> "$dyno_path/dyno.list"
}

# deps
md5=$(check_for md5sum)
awk=$(check_for awk)

# arguments and logic
case $# in
    0)
        build_it
        ;;
    *)
        store_it "$@"
        ;;
esac

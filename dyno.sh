#!/bin/bash
# vi: syntax=sh ts=4 expandtab

# options
#DYNO_PATH=""

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
    mkdir -p "$DYNO_PATH/dynos"
    echo "$content" > "$DYNO_PATH/dynos/$hash"
    list_it $(date +%s) $hash
}

list_it() {
    echo "$1 $2" >> "$DYNO_PATH/dyno.list"
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

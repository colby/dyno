#!/bin/bash
# vi: syntax=sh ts=4 expandtab

set -e
# variables
#DYNO_PATH=""
DIR="$DYNO_PATH/dynos"
LIST="$DYNO_PATH/dyno.list"
INDEX="$DYNO_PATH/index.html"

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

_track() {
    echo "$1 $2 $3" >> $LIST
}

header() {
cat > $INDEX <<EOL
<!DOCTYPE html>
<html>
<head>
<title>Dyno!</title>
</head>
<body>
EOL
}

footer() {
cat >> $INDEX <<EOL
</body>
</html>
EOL
}

# deps
md5=$(_check md5sum)
sed=$(_check sed)
date=$(_check gdate)
edit=$(which $EDITOR || errcho 'Missing variable: $EDITOR')

# arguments and logic
now=$($date +%s)

case $# in
    0)
        header
        while read line; do
            set -- $line
            fulldate=$($date --date="@$1")
            post="$DIR/$3"
            title=$(head -n1 "$DIR/$3")
            echo "<a href='$post'>$title</a>" >> "$INDEX"
        done < $LIST
        footer
        ;;
    1)
        if [ ${#1} == 10 ]; then
            while read line; do
                set -- $line
                [ $2 -lt $now ] && $sed -i "/^$1/d" "$LIST"
            done < $LIST
        fi
        [ ${#1} == 32 ] && $edit "$DIR/$1"
        ;;
    *)
        # default is die in +5 years
        die=$($date -d '+5 year' "+%s")
        content="$*"
        hash=$(_hash "$content")
        _track "$now" "$die" "$hash"
        _store "$hash" "$content"
        ;;
esac

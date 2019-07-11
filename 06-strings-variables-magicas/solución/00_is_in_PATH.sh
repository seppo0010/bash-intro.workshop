#!/bin/bash

function is_in_path() {
    while read -d: -r p; do
        if [ "$p" == "$1" ]; then
            return 0
        fi
    done <<<$(printf "$PATH")
    return 1
}
for path in /bin /test /tmp /usr/bin; do
    if is_in_path "$path"; then
        echo "$path is in path"
    else
        echo "$path is not in path"
    fi
done

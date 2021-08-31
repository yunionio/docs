#!/bin/bash

make clean

(
    mkdir ./public
    cd ./public && python3 -m http.server 28066 &
)

function watch_dir() {
    case "$OSTYPE" in
        linux*)
            watch='inotifywait -e modify -r' ;;
        darwin*)
            watch='fswatch -r -v -1' ;;
        *)
            exit 1 ;;
    esac
    $watch $@
}

while watch_dir ./content/; do
    make saas-build-domain
done

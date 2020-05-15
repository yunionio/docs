#!/bin/bash

VERSIONS_ARRAY=(
    'master'
    'v2.12'
    'v2.11'
)

join_versions() {
    versions=$(printf ",%s" "${VERSIONS_ARRAY[@]}")
    echo ${versions:1}
}

VERSIONS_STRING=$(join_versions)

run() {
    export CURRENT_BRANCH="master"
    export CURRENT_VERSION=${VERSIONS_ARRAY[0]}
    export VERSIONS=${VERSIONS_STRING}
    HUGO_TITLE="Onecloud Doc - local"
    CURRENT_BRANCH="master"

    CURRENT_VERSION=${CURRENT_VERSION} hugo server -w
}

run

#!/bin/bash

#set -e

GREEN='\033[32;1m'
RESET='\033[0m'

HOST=https://opensource.yunion.cn

# TODO - Maybe get list of released versions from Github API and filter
# those which have docs.

# Place the latest version at the beginning so that version selector can
# append '(latest)' to the version string, and build script can place the
# artifact in an appropriate location
VERSION_ARRAY=(
'v3.7'
'v3.6'
'v3.4'
'v3.3'
'v3.2'
)

join_versions() {
    versions=$(printf ",%s" "${VERSION_ARRAY[@]}")
    echo ${versions:1}
}

version() {
    echo "$@" | gawk -F. '{ printf("%03d%03d%03d\n", $1,$2,$3); }'
}

rebuild() {
    echo -e "$(date) $GREEN Updateing docs for branch: $1.$RESET"

    # The latest documentation is generated in the root of /public dir
    # Older documentations are generated in their respective `/public/vx.x.x` dirs
    dir=''
    title='OneCloud'
    if [[ $2 != "${VERSION_ARRAY[0]}" ]]; then
        dir=$2
        title="$title $2"
    fi

    VERSION_STRING=$(join_versions)
    export CURRENT_BRANCH=${1}
    export CURRENT_VERSION=${2}
    export VERSIONS=${VERSION_STRING}

    cmd=hugo
    HUGO_TITLE="$title" \
    VERSIONS=${VERSION_STRING} \
        CURRENT_BRANCH=${1} \
        CURRENT_VERSION=${2} $cmd \
        --destination=public/"$dir" \
        --baseURL="$HOST"/"$dir" 1> /dev/null
}

branch_updated() {
    local branch="$1"
    git checkout -q "$1"
    UPSTREAM=$(git rev-parse "@{u}")
    LOCAL=$(git rev-parse "@")

    if [ "$LOCAL" != "$UPSTREAM" ]; then
        git merge -q upstream/"$branch"
        return 0
    else
        return 1
    fi
}

public_folder() {
    dir=''
    if [[ $1 == "${VERSION_ARRAY[0]}" ]]; then
        echo "public"
    else
        echo "public/$1"
    fi
}

check_and_update() {
    local version="$1"
    local branch=""

    if [[ $version == "master" ]]; then
        branch="master"
    else
        branch="release/${version#v}"
    fi

    if branch_updated "$branch"; then
        git merge -q upstream/"$branch"
        rebuild "$branch" "$version"
    fi

    folder=$(public_folder $version)
    if [ "$first_run" = 1 ] || [ ! -d $folder ]; then
        rebuild "$branch" "$version"
    fi
}

first_run=1
while true; do
    # Lets move to docs directory.
    pushd $(dirname "$0")/.. > /dev/null

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if branch_updated "master"; then
        echo -e "$(date) Now will update the docs.$RESET"
    fi

    echo -e "$(date) Starting to check branches."
    git remote update > /dev/null

    for version in "${VERSION_ARRAY[@]}"; do
        check_and_update "$version"
    done

    echo -e "$(date) Done checking branches.\n"

    git checkout -q "$current_branch"
    popd > /dev/null

    first_run=0
    if [ -n "$EXIT_AFTER_BUILD" ]; then
        exit 0
    fi
    sleep 60
done

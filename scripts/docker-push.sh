#!/bin/bash
set -o errexit
set -o pipefail

if [ "$DEBUG" == "true" ]; then
    set -ex ;export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
fi

pushd $(dirname $(dirname "$BASH_SOURCE")) > /dev/null
CUR_DIR=$(pwd)
SRC_DIR=$CUR_DIR
popd > /dev/null

DOCKER_DIR="$SRC_DIR"

REGISTRY=${REGISTRY:-registry.cn-beijing.aliyuncs.com/yunionio}
NAME=${NAME:-docs}
TAG=${TAG:-latest}

build_image() {
    local tag=$1
    local file=$2
    local path=$3
    docker build -t "$tag" -f "$file" "$path"
}

push_image() {
    local tag=$1
    docker push "$tag"
}

docker_buildx(){
    local tag=$1
    local file=$2
    local path=$3
    local platform="linux/$ARCH"
    if [[ "$ARCH" == "all" ]]; then
        platform="linux/arm64,linux/amd64"
    fi
    docker buildx build --platform="$platform" -t "$tag" -f "$file" "$path" --push
    docker pull $tag
}

img_name="$REGISTRY/$NAME:$TAG"

case $ARCH in
    amd64 | "" )
        build_image "$img_name" "$DOCKER_DIR/Dockerfile-img" "$SRC_DIR"
        push_image "$img_name"
        ;;
    arm64)
        docker_buildx "$img_name-arm64" "$DOCKER_DIR/Dockerfile-img" "$SRC_DIR"
        ;;
    all)
        docker_buildx "$img_name" "$DOCKER_DIR/Dockerfile-img" "$SRC_DIR"
        ;;
esac


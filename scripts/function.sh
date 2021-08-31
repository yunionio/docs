#!/bin/bash

generate_config() {
    case "$OSTYPE" in
        linux*)
            sedi='sed -i' ;;
        darwin*)
            sedi='sed -i ""' ;;
        *) ;;
    esac

    local origin_config=$1
    # if [ -z "$OEM_MODE" ]; then
        # echo $origin_config
        # return
    # fi

    local config_dir="$(dirname $origin_config)"
    local temp_config="/tmp/yuniondocs_oem.toml"
    cat "$origin_config" > "$temp_config"
    if [ -n "$OEM" ]; then
        $sedi "s|oem =.*|oem = \"$OEM\"|g" "$temp_config"
    fi
    if [ -n "$OEM_NAME" ]; then
        $sedi "s|oem_name =.*|oem_name = \"$OEM_NAME\"|g" "$temp_config"
    fi

    if [ -n "$CONTENT_DIR" ]; then
        $sedi "s|contentDir = \"content/zh\"|contentDir= \"$CONTENT_DIR/zh\"|g" "$temp_config"
        $sedi "s|contentDir = \"content/en\"|contentDir= \"$CONTENT_DIR/en\"|g" "$temp_config"
    fi

    if [ "$OEM" != "aisenzhe" ]; then
        # always set no_logo
        $sedi "s|no_logo =.*|no_logo = true|g" "$temp_config"
    fi

    echo "$temp_config"
}

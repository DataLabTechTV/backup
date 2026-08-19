#!/usr/bin/env bash

if [ "${_lib_config_loaded:-0}" = "1" ]; then
    return 0
fi

_lib_config_loaded=1

_lib_config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _lib_config_dir

. "$_lib_config_dir/logging.sh"
. "$_lib_config_dir/constants.sh"

check_config() {
    if [ -z "$config_file" ]; then
        error "Configuration file not set"
        return 1
    fi

    if [ ! -r "$config_file" ]; then
        error "Configuration file not readable" "$config_file"
        return 1
    fi

    if [ "$#" -lt 1 ]; then
        return 0
    fi

    config="$1"

    if [ -z "${!config:-}" ]; then
        if [ "$#" -ge 2 ] && [ -n "$2" ]; then
            warn "Using default value" "${config}=$2"
            printf -v "$config" '%s' "$2"
        else
            error "Configuration not set" "$config"
            return 1
        fi
    fi

    debug "$config" "${!config:-}"
}

load_config() {
    check_config

    set -a
    # shellcheck source=/dev/null
    source "$config_file"
    set +a
}

load_sources() {
    src_dirs=()

    if [ -z "$sources_file" ]; then
        error "Sources file not set"
        return 1
    fi

    if [ ! -r "$sources_file" ]; then
        warn "Sources file not readable" "$sources_file"
        return 0
    fi

    mapfile -t src_dirs <"$sources_file"

    for i in "${!src_dirs[@]}"; do
        src_dirs[i]="$(readlink -f -- "${src_dirs[i]/#\~/$HOME}")"
    done
}

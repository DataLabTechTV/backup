#!/usr/bin/env bash

if [ "${_lib_logging_loaded:-0}" = "1" ]; then
    return 0
fi

_lib_logging_loaded=1

_lib_logging_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _lib_logging_dir

. "$_lib_logging_dir/colors.sh"

log() {
    local level=$1
    shift

    local color prefix

    case "$level" in
        INFO)
            color="$cinfo"
            prefix='I'
            ;;
        WARN)
            color="$cwarn"
            prefix='W'
            ;;
        ERROR)
            color="$cerror"
            prefix='E'
            ;;
        DEBUG)
            color="$cdebug"
            prefix='D'
            ;;
        *)
            printf 'log: invalid level: %s\n' "$level" >&2
            return 2
    esac

    local msg="$1"
    shift

    local value=
    if [ "$#" -ge 1 ]; then
        value=": ${cvalue}$*"
    fi

    printf '%b%s: %s%b%s%b\n' \
        "$color" "$prefix" "$msg" "$creset" \
        "$value" "$creset" \
        >&2
}

info() {
    log INFO "$@"
}

warn() {
    log WARN "$@"
}

error() {
    log ERROR "$@"
}

debug() {
    [ "${DEBUG:-0}" = "1" ] || return 0
    log DEBUG "$@"
}

log_demo() {
    info "information message"
    warn "warning message"
    error "error message"
    debug "debug message"

    info "information message" "some value"
    warn "warning message" "some value"
    error "error message" "some value"
    debug "debug message" "some value"
}

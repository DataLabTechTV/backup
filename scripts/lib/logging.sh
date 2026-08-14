#!/usr/bin/env bash

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$LIB_DIR/colors.sh"

log() {
    level=$1
    shift

    case $level in
        INFO)
            color=$INFO
            prefix=I
            ;;
        WARN)
            color=$WARN
            prefix=W
            ;;
        ERROR)
            color=$ERROR
            prefix=E
            ;;
        DEBUG)
            color=$DEBUG
            prefix=D
            ;;
        *)
            echo "log: invalid level: $level"
            return 2
    esac

    msg="$1"
    shift

    value=
    if [ "$#" -ge 1 ]; then
        value=": ${VALUE}$1"
        shift
    fi

    printf "${color}$prefix: $msg${value}${RESET}\n" "$@" >&2
}

log_demo() {
    log INFO "information message"
    log WARN "warning message"
    log ERROR "error message"
    log DEBUG "debug message"

    log INFO "information message" "value"
    log WARN "warning message" "value"
    log ERROR "error message" "value"
    log DEBUG "debug message" "value"
}

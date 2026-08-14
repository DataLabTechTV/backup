#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$SCRIPT_DIR/lib/logging.sh"
. "$SCRIPT_DIR/lib/colors.sh"
. "$SCRIPT_DIR/lib/prompt.sh"
. "$SCRIPT_DIR/lib/constants.sh"

check_config() {
    if [ -z "$CONFIG_FILE" ]; then
        log ERROR "Configuration file not set"
        return 2
    fi

    if [ ! -r "$CONFIG_FILE" ]; then
        log ERROR "Configuration file not readable" "$CONFIG_FILE"
        return 2
    fi

    if [ "$#" -lt 1 ]; then
        return
    fi

    config="$1"

    if [ -z "${!config:-}" ]; then
        log ERROR "Configuration not set" "$config"
        return 2
    fi
}

check_config DLT_BACKUP_BORG_REPO

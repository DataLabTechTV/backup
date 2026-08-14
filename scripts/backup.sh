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
        return 1
    fi

    if [ ! -r "$CONFIG_FILE" ]; then
        log ERROR "Configuration file not readable" "$CONFIG_FILE"
        return 1
    fi

    if [ "$#" -lt 1 ]; then
        return 0
    fi

    config="$1"

    if [ -z "${!config:-}" ]; then
        log ERROR "Configuration not set" "$config"
        return 1
    fi
}

check_config DLT_BACKUP_BORG_REPO

if [ -d "$DLT_BACKUP_BORG_REPO" ]; then
    log ERROR "Borg repository not a directory" "$DLT_BACKUP_BORG_REPO"
    exit 1
fi

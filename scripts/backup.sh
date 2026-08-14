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

load_config() {
    check_config

    set -a
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
    set +a
}

load_config
check_config DLT_BACKUP_BORG_REPO

DLT_BACKUP_BORG_REPO="$(readlink -f "$DLT_BACKUP_BORG_REPO")"

if [ ! -d "$DLT_BACKUP_BORG_REPO" ]; then
    log ERROR "Borg repository not a directory" "$DLT_BACKUP_BORG_REPO"
    exit 1
fi

if ! borg info "$DLT_BACKUP_BORG_REPO" &>/dev/null; then
    if [ -n "$(find "$DLT_BACKUP_BORG_REPO" -mindepth 1 -maxdepth 1)" ]; then
        log ERROR "Borg repository directory not empty" "$DLT_BACKUP_BORG_REPO"
        exit 1
    fi

    log INFO "Initializing borg repository" "$DLT_BACKUP_BORG_REPO"
    # TODO borg init
fi

# TODO borg create (backup)
# TODO borg prune
# TODO borg compact

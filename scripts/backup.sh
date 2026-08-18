#!/usr/bin/env bash

set -euo pipefail

_backup_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _backup_script_dir

. "$_backup_script_dir/lib/logging.sh"
. "$_backup_script_dir/lib/colors.sh"
. "$_backup_script_dir/lib/prompt.sh"
. "$_backup_script_dir/lib/constants.sh"

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
        error "Configuration not set" "$config"
        return 1
    fi
}

load_config() {
    check_config

    set -a
    # shellcheck source=/dev/null
    source "$config_file"
    set +a
}

load_config
check_config DLT_BACKUP_BORG_REPO

DLT_BACKUP_BORG_REPO="$(readlink -f "$DLT_BACKUP_BORG_REPO")"

if [ ! -d "$DLT_BACKUP_BORG_REPO" ]; then
    error "Borg repository not a directory" "$DLT_BACKUP_BORG_REPO"
    exit 1
fi

if ! borg info "$DLT_BACKUP_BORG_REPO" &>/dev/null; then
    if [ -n "$(find "$DLT_BACKUP_BORG_REPO" -mindepth 1 -maxdepth 1)" ]; then
        error "Borg repository directory not empty" "$DLT_BACKUP_BORG_REPO"
        exit 1
    fi

    info "Initializing borg repository" "$DLT_BACKUP_BORG_REPO"
    # TODO borg init
fi

# TODO borg create (backup)
# TODO borg prune
# TODO borg compact

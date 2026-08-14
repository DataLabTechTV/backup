#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$SCRIPT_DIR/lib/logging.sh"
. "$SCRIPT_DIR/lib/colors.sh"
. "$SCRIPT_DIR/lib/prompt.sh"
. "$SCRIPT_DIR/lib/constants.sh"

if [ ! -e "$CONFIG_DIR" ]; then
    log INFO "Creating configuration directory" "$CONFIG_DIR"
    mkdir -vp "$CONFIG_DIR"
fi

if [ -e "$CONFIG_FILE" ]; then
    prompt "Overwrite '$CONFIG_FILE'? [yN]" overwrite
    if [ "${overwrite?}" != "y" ]; then
        log ERROR "Configuration file overwrite denied by user"
        exit 1
    fi
fi

prompt "Borg repository directory" DLT_BACKUP_BORG_REPO

log INFO "Writing configuration" "$CONFIG_FILE"

echo -n "$DEBUG"
cat <<EOF | tee "$CONFIG_FILE"
DLT_BACKUP_BORG_REPO="$DLT_BACKUP_BORG_REPO"
EOF
echo -n "$RESET"

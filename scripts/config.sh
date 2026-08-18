#!/usr/bin/env bash

set -euo pipefail

_config_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _CONFIG_SCRIPT_DIR

. "$_config_script_dir/lib/logging.sh"
. "$_config_script_dir/lib/colors.sh"
. "$_config_script_dir/lib/prompt.sh"
. "$_config_script_dir/lib/constants.sh"

if [ ! -e "$config_dir" ]; then
    log INFO "Creating configuration directory" "$config_dir"
    mkdir -vp "$config_dir"
fi

if [ -e "$config_file" ]; then
    prompt "Overwrite '$config_file'? [yN]" overwrite
    if [ "${overwrite?}" != "y" ]; then
        log ERROR "Configuration file overwrite denied by user"
        exit 1
    fi
fi

prompt "Borg repository directory" DLT_BACKUP_BORG_REPO

log INFO "Writing configuration" "$config_file"

echo -n "$cdebug"
cat <<EOF | tee "$config_file"
DLT_BACKUP_BORG_REPO=$DLT_BACKUP_BORG_REPO
EOF
echo -n "$creset"

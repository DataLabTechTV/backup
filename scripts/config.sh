#!/usr/bin/env bash

set -euo pipefail

_config_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _CONFIG_SCRIPT_DIR

. "$_config_script_dir/lib/logging.sh"
. "$_config_script_dir/lib/colors.sh"
. "$_config_script_dir/lib/prompt.sh"
. "$_config_script_dir/lib/constants.sh"

info "Configuration started" "$(date --iso-8601=seconds)"

if [ ! -e "$config_dir" ]; then
    info "Creating configuration directory" "$config_dir"
    mkdir -vp "$config_dir"
fi

if [ -e "$config_file" ] || [ -e "$sources_file" ]; then
    prompt "Overwrite '$config_file' and '$sources_file'? [yN]" overwrite
    if [ "${overwrite?}" != "y" ]; then
        error "Configuration canceled"
        exit 1
    fi
fi

prompt "Borg repository directory" borg_repo

src_dirs=()
while true; do
    prompt "Source directory to backup" src_dir
    if [ -z "$src_dir" ]; then
        continue
    fi

    src_dirs+=( "$src_dir" )

    prompt "Add more? [Yn]" add_more
    if [ "${add_more?}" = "n" ]; then
        break
    fi
done

info "Writing configuration" "$config_file"

printf '%b' "$cdebug"
cat <<EOF | tee "$config_file"
borg_repo=$borg_repo
EOF
printf '%b' "$creset"

info "Writing sources" "$sources_file"

printf '%b' "$cdebug"
printf '%s\n' "${src_dirs[@]}" | tee "$sources_file"
printf '%b' "$creset"

info "Configuration done" "$(date --iso-8601=seconds)"

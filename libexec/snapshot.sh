#!/usr/bin/env bash

set -euo pipefail

_snapshot_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _snapshot_script_dir

. "$_snapshot_script_dir/../lib/logging.sh"
. "$_snapshot_script_dir/../lib/config.sh"

if [ "$#" -lt 2 ]; then
    echo "snapshot.sh: missing arguments TARGET_DIR and PREFIX"
    exit 2
fi

target_dir="$1"
prefix="$2"

info "Snapshot started" "$(date --iso-8601=seconds)"

if [ -e "$target_dir" ] && [ ! -d "$target_dir" ]; then
    error "TARGET_DIR not a directory" "$target_dir"
    exit 1
fi

mkdir -p "$target_dir"

load_config
check_config borg_repo

latest_archive="$(borg list --last 1 --format '{archive}' "${borg_repo?}")"
filename="${latest_archive//-}"
filename="${latest_archive/T/_}"
snapshot_file="${target_dir}/${prefix}${filename}.tar.gz"

info "Exporting archive" "$snapshot_file"
borg export-tar "${borg_repo?}::${latest_archive}" "$snapshot_file"

info "Snapshot done" "$(date --iso-8601=seconds)"

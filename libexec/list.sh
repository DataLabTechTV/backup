#!/usr/bin/env bash

set -euo pipefail

_list_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _list_script_dir

. "$_list_script_dir/../lib/logging.sh"
. "$_list_script_dir/../lib/config.sh"

info "Archive listing started" "$(date --iso-8601=seconds)"

load_config
check_config borg_repo
borg list "${borg_repo?}"

info "Archive listing done" "$(date --iso-8601=seconds)"

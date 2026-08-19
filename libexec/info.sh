#!/usr/bin/env bash

set -euo pipefail

_info_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _info_script_dir

. "$_info_script_dir/../lib/logging.sh"
. "$_info_script_dir/../lib/config.sh"

info "Repository info request started" "$(date --iso-8601=seconds)"

load_config
check_config borg_repo
borg info "${borg_repo?}"

info "Repository info request done" "$(date --iso-8601=seconds)"

#!/usr/bin/env bash

set -euo pipefail

_backup_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _backup_script_dir

. "$_backup_script_dir/../lib/logging.sh"
. "$_backup_script_dir/../lib/prompt.sh"
. "$_backup_script_dir/../lib/constants.sh"
. "$_backup_script_dir/../lib/config.sh"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --notify|-n)
            notify=1
            ;;
        --notify-once-daily|-o)
            notify_once_daily=1
            ;;
    esac

    shift
done

info "Backup started" "$(date --iso-8601=seconds)"

load_config
check_config borg_repo
check_config keep_within 1d
check_config keep_daily 7
check_config keep_weekly 4
check_config keep_monthly 12

if [ ! -d "${borg_repo?}" ]; then
    error "Borg repository not a directory" "$borg_repo"
    exit 1
fi

if ! borg info "$borg_repo" &>/dev/null; then
    if [ -n "$(find "$borg_repo" -mindepth 1 -maxdepth 1)" ]; then
        error "Borg repository directory not empty" "$borg_repo"
        exit 1
    fi

    info "Initializing borg repository" "$borg_repo"
    borg init --encryption=none "$borg_repo"
fi

load_sources

if [ "${#src_dirs[@]}" -eq 0 ]; then
    warn "No source directories to backup" "$sources_file"
    error "Backup skipped due to missing source directories"
    exit 1
fi

debug "Source directories" "${src_dirs[@]}"

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

borg create \
    --verbose \
    --list \
    "$borg_repo::{now}" \
    "${src_dirs[@]}" 2>&1 |
    tee "$tmpfile"

stat_date="$(awk '/^Creating archive at/ { match($0, "::([^\"]+)\"", m); print m[1] }' "$tmpfile" || true)"
stat_added="$(grep -c '^A ' "$tmpfile" || true)"
stat_modified="$(grep -c '^M ' "$tmpfile" || true)"

info "Pruning old backups"
borg prune \
    --list \
    --stats \
    --keep-within="${keep_within?}" \
    --keep-daily="${keep_daily?}" \
    --keep-weekly="${keep_weekly?}" \
    --keep-monthly="${keep_monthly?}" \
    "$borg_repo"

info "Compacting borg repository"
borg compact "$borg_repo"

info "Showing borg repository information"
borg info "$borg_repo"

if [ -n "${notify:-}" ]; then
    mkdir -p "$state_dir"

    now="$(date --iso-8601=seconds)"
    today="$(echo "$now" | cut -dT -f1)"
    show=1

    if [ -n "${notify_once_daily:-}" ] && [ -e "$last_run_file" ]; then
        last_run="$(cat "$last_run_file")"
        last_date="$(echo "$last_run" | cut -dT -f1)"
        [ "$last_date" = "$today" ] && show=0
    fi

    if [ "$show" -eq 1 ]; then
        notify-send \
            --icon "backup" \
            --app-name "DLT Backup" \
            "Borg archive created" \
            "$stat_date<br>$stat_added added, $stat_modified modified"

    fi

    echo "$now" >"$last_run_file"
fi

info "Backup done" "$(date --iso-8601=seconds)"

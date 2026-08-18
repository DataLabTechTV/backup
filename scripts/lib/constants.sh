#!/usr/bin/env bash

if [ "${_lib_constants_loaded:-0}" = "1" ]; then
    return 0
fi

_lib_constants_loaded=1

config_root="${XDG_CONFIG_HOME:-$HOME/.config}"

config_dir="$config_root/dlt/backup"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/dlt/backup"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dlt/backup"

config_file="$config_dir/config"
sources_file="$config_dir/sources"

systemd_user_dir="$config_root/systemd/user"

readonly config_root config_dir data_dir state_dir config_file sources_file systemd_user_dir

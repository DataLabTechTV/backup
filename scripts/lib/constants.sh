#!/usr/bin/env bash

if [ "${_lib_constants_loaded:-0}" = "1" ]; then
    return 0
fi

_lib_constants_loaded=1

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dlt/backup"
config_file="$config_dir/config"

local_dir="${XDG_DATA_HOME:-$HOME/.local/share}/dlt/backup"

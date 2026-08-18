#!/usr/bin/env bash

if [ "${_lib_prompt_loaded:-0}" = 1 ]; then
    return 0
fi

_lib_prompt_loaded=1

_lib_prompt_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _lib_prompt_dir

. "$_lib_prompt_dir/colors.sh"

prompt() {
    if [ "$#" -lt 2 ]; then
        echo "prompt: must provide message and target environment variable"
        return 2
    fi

    local msg _input_var def

    msg="$(echo "$1" | sed -E "s/'([^']*)'/${cvalue}\1${cprompt}/g")"
    _input_var="$2"

    extra_args=()
    if [ "$#" -ge 3 ]; then
        def="$3"
        extra_args+=( -i "$def" )
    fi

    read -e -r "${extra_args[@]}" -p "${cprompt}${msg}: $creset" "${_input_var?}"
    printf '%s' "$creset"

    if [ "$#" -ge 3 ] && [ -z "${!_input_var}" ]; then
        printf -v "$_input_var" '%s' "$def"
    fi
}

prompt_demo() {
    prompt "Enter" val
    echo "ANS: $val"

    prompt "Enter default" val 1d
    echo "ANS: $val"

    prompt "Check file '/tmp/test' or 'blah'? [yN]" val
    echo "ANS: $val"
}

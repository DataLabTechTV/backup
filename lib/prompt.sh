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

    msg="$(echo "$1" | sed -E "s/'([^']*)'/${cvalue}\1${cprompt}/g")"
    var="$2"

    read -e -r -p "${cprompt}${msg}: $creset" "${var?}"
    printf '%s' "$creset"
}

prompt_demo() {
    prompt "Enter" var
    echo "ANS: $var"

    prompt "Check file '/tmp/test' or 'blah'? [yN]" var
    echo "ANS: $var"
}

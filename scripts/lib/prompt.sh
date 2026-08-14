#!/usr/bin/env bash

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$LIB_DIR/colors.sh"

prompt() {
    if [ "$#" -lt 2 ]; then
        echo "prompt: must provide message and target environment variable"
        return 1
    fi

    msg="$(echo "$1" | sed -E "s/'([^']*)'/${VALUE}\1${PROMPT}/g")"
    var="$2"

    read -e -r -p "${PROMPT}${msg}: $RESET" "${var?}"
    printf '%s' "$RESET"
}

prompt_demo() {
    prompt "Enter" var
    echo "ANS: $var"

    prompt "Check file '/tmp/test' or 'blah'? [yN]" var
    echo "ANS: $var"
}

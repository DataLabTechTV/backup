#!/usr/bin/env bash

if [ "${_lib_colors_loaded:-0}" = 1 ]; then
    return 0
fi

_lib_colors_loaded=1

if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
    # General
    cbold=$(tput bold)
    creset=$(tput sgr0)
    cvalue="$(tput setaf 5)"

    # Prompt
    cprompt="${cbold}$(tput setaf 4)"

    # Logging
    cinfo=$(tput setaf 4)
    cwarn=$(tput setaf 3)
    cerror=$(tput setaf 1)
    cdebug=$(tput setaf 8)
else
    cbold=
    creset=
    cvalue=

    cprompt=

    cinfo=
    cwarn=
    cerror=
    cdebug=
fi

readonly cbold creset cvalue cprompt cinfo cwarn cerror cdebug

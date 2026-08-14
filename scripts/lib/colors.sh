#!/usr/bin/env bash

# General
BOLD=$(tput bold)
RESET=$(tput sgr0)
VALUE="$(tput setaf 5)"

# Prompt
PROMPT="$BOLD$(tput setaf 4)"

# Logging
INFO=$(tput setaf 4)
WARN=$(tput setaf 3)
ERROR=$(tput setaf 1)
DEBUG=$(tput setaf 8)

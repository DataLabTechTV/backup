# List all recipes
default:
    just -l

_check bin:
    #!/usr/bin/env bash
    set -euo pipefail
    echo -n "Checking {{ bin }}... "
    test -x "$(command -v {{ bin }})" || (echo "failed (no executable {{ bin }} was found)"; exit 1)
    echo ok

check:
    #!/usr/bin/env bash
    set -e
    just _check borg

# Run interactive configuration script
config:
    ./scripts/config.sh

# Run backup script (expects existing config)
backup:
    ./scripts/backup.sh

# Install or reinstall backup user service
install: check
    # ${XDG_DATA_HOME:-$HOME/.local/share}/dlt/backup
    # install ...

# Uninstall backup user service
uninstall:

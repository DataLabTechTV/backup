# List all recipes
default:
    just -l -u

_check bin:
    #!/usr/bin/env bash
    set -euo pipefail
    echo -n "Checking {{ bin }}... "
    test -x "$(command -v {{ bin }})" || (echo "failed (no executable {{ bin }} was found)"; exit 1)
    echo ok

# Check if required dependencies are available
check:
    #!/usr/bin/env bash
    set -e
    just _check borg

# Run interactive configuration script
[group('run')]
config:
    ./scripts/config.sh

# Run backup script (expects existing config)
[group('run')]
backup *args:
    ./scripts/backup.sh {{ args }}

# Install backup scripts and systemd user units
[group('manage')]
install: check
    #!/usr/bin/env bash
    set -euxo pipefail

    source ./scripts/lib/constants.sh

    install -d "$data_dir" "$data_dir/lib"
    install -Dm755 ./scripts/*.sh "$data_dir/"
    install -Dm644 ./scripts/lib/*.sh "$data_dir/lib/"

    install -Dm644 ./systemd/user/dlt-backup.service "$systemd_user_dir/dlt-backup.service"
    install -Dm644 ./systemd/user/dlt-backup.timer "$systemd_user_dir/dlt-backup.timer"
    systemctl --user daemon-reload
    systemctl --user enable --now dlt-backup.timer

# Uninstall backup scripts and systemd user units
[group('manage')]
uninstall:
    #!/usr/bin/env bash
    set -euxo pipefail

    source ./scripts/lib/constants.sh

    systemctl --user disable --now dlt-backup.timer
    rm -fv "$systemd_user_dir"/dlt-backup.*
    systemctl --user daemon-reload

    rm -rfv "$data_dir"

# List all recipes
default:
    @just -l -u

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
    ./bin/dlt-backup config

# Run backup script (expects existing config)
[group('run')]
backup *args:
    ./bin/dlt-backup {{ args }}

# Exports the latest backup as a target tar.gz file
[group('run')]
snapshot target_dir="./output" prefix="snapshot-":
    ./bin/dlt-backup snapshot {{ target_dir }} {{ prefix }}

# List backup archives
[group('run')]
list:
    ./bin/dlt-backup list

# Show repository information
[group('run')]
info:
    ./bin/dlt-backup info

# Install backup scripts and systemd user units
[group('manage')]
install: check
    #!/usr/bin/env bash
    set -euxo pipefail

    source ./lib/constants.sh

    install -d "$data_dir/lib"
    install -Dm644 ./lib/*.sh "$data_dir/lib/"
    install -d "$data_dir/libexec"
    install -Dm755 ./libexec/*.sh "$data_dir/libexec"
    install -Dm755 ./bin/dlt-backup "$bin_dir"

    install -Dm644 ./systemd/user/dlt-backup.service "$systemd_user_dir/dlt-backup.service"
    install -Dm644 ./systemd/user/dlt-backup.timer "$systemd_user_dir/dlt-backup.timer"
    systemctl --user daemon-reload
    systemctl --user enable --now dlt-backup.timer

# Uninstall backup scripts and systemd user units
[group('manage')]
uninstall:
    #!/usr/bin/env bash
    set -euxo pipefail

    source ./lib/constants.sh

    systemctl --user disable --now dlt-backup.timer
    rm -fv "$systemd_user_dir"/dlt-backup.*
    systemctl --user daemon-reload

    rm -fv "$bin_dir/dlt-backup"
    rm -rfv "$data_dir"

#!/usr/bin/env bash
set -euo pipefail

panic="$(dirname "$0")/panic.sh"
state="${XDG_STATE_HOME:-"$HOME/.local/state"}/hypr-panic"
marker="$state/restore-on-unlock"
mkdir -p "$state"

if [ "${1:-}" = restore ]; then
    if [ -f "$marker" ]; then
        "$panic" -r
        rm "$marker"
    fi
    exit 0
fi

# Restore via the unlock hook: Noctalia's lock IPC returns before authentication.
if [ -f "$marker" ]; then
    noctalia msg session lock
    exit
fi
"$panic" -p
touch "$marker"
if ! noctalia msg session lock; then
    "$panic" -r
    rm "$marker"
    exit 1
fi

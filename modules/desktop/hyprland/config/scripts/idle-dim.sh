#!/usr/bin/env bash
set -euo pipefail

state="${XDG_RUNTIME_DIR:?}/gammashift-idle"
gammashift="${XDG_CONFIG_HOME:-"$HOME/.config"}/scripts/gammashift.sh"

if [ "${1:-}" = restore ]; then
    if [ -d "$state" ]; then
        "$gammashift" Brightness undo 0.3 &
        "$gammashift" Gamma undo 0.3
        wait
        rmdir "$state"
    fi
    exit 0
fi

[ "${1:-}" = dim ] || exit 0

# A single marker prevents the locked and unlocked timers dimming twice.
if mkdir "$state" 2>/dev/null; then
    "$gammashift" Brightness /3 1.5 &
    "$gammashift" Gamma '*1.2' 1.5
    wait
fi

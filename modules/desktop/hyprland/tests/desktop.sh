#!/usr/bin/env bash
set -euo pipefail

feature="$(cd "$(dirname "$0")/.." && pwd)"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
export XDG_CONFIG_HOME="$scratch/config"
export XDG_STATE_HOME="$scratch/state"
export XDG_RUNTIME_DIR="$scratch/runtime"
export TEST_LOG="$scratch/commands"
export TEST_LOCK_FAIL=0
mkdir -p "$scratch/bin" "$XDG_RUNTIME_DIR"
export PATH="$scratch/bin:$PATH"

cat > "$scratch/bin/noctalia" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$TEST_LOG"
if [ "$*" = 'msg session lock' ] && [ "$TEST_LOCK_FAIL" = 1 ]; then
    exit 1
fi
EOF
chmod +x "$scratch/bin/noctalia"
sed -i "1c#!$(command -v bash)" "$scratch/bin/noctalia"

mkdir -p "$scratch/panic"
cp "$feature/config/scripts/panic/lock.sh" "$scratch/panic/"
cat > "$scratch/panic/panic.sh" <<'EOF'
#!/usr/bin/env bash
printf 'panic %s\n' "$*" >> "$TEST_LOG"
EOF
chmod +x "$scratch/panic/panic.sh"
sed -i "1c#!$(command -v bash)" "$scratch/panic/panic.sh"

: > "$TEST_LOG"
bash "$scratch/panic/lock.sh"
test -f "$XDG_STATE_HOME/hypr-panic/restore-on-unlock"
test "$(grep -c '^panic -p$' "$TEST_LOG")" = 1
bash "$scratch/panic/lock.sh"
test "$(grep -c '^panic -p$' "$TEST_LOG")" = 1
bash "$scratch/panic/lock.sh" restore
test ! -f "$XDG_STATE_HOME/hypr-panic/restore-on-unlock"
test "$(grep -c '^panic -r$' "$TEST_LOG")" = 1
bash "$scratch/panic/lock.sh" restore
test "$(grep -c '^panic -r$' "$TEST_LOG")" = 1
export TEST_LOCK_FAIL=1
if bash "$scratch/panic/lock.sh"; then
    echo "Failed lock unexpectedly succeeded" >&2
    exit 1
fi
test ! -f "$XDG_STATE_HOME/hypr-panic/restore-on-unlock"
test "$(grep -c '^panic -r$' "$TEST_LOG")" = 2

# Restore-only must not change workspaces when there is no saved state.
bash "$feature/config/scripts/panic/panic.sh" -r

echo "Desktop script tests passed"

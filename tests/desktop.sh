#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
export XDG_CONFIG_HOME="$scratch/config"
export XDG_STATE_HOME="$scratch/state"
export XDG_RUNTIME_DIR="$scratch/runtime"
export TEST_LOG="$scratch/commands"
export TEST_LOCKED=false
export TEST_LOCK_FAIL=0
mkdir -p "$scratch/bin" "$XDG_CONFIG_HOME/scripts" "$XDG_RUNTIME_DIR"
export PATH="$scratch/bin:$PATH"

cat > "$scratch/bin/noctalia" <<'EOF'
#!/usr/bin/env bash
if [ "$*" = 'msg status' ]; then
    printf '{"locked":%s}\n' "$TEST_LOCKED"
    exit
fi
printf '%s\n' "$*" >> "$TEST_LOG"
if [ "$*" = 'msg session lock' ] && [ "$TEST_LOCK_FAIL" = 1 ]; then
    exit 1
fi
EOF
cat > "$XDG_CONFIG_HOME/scripts/gammashift.sh" <<'EOF'
#!/usr/bin/env bash
printf 'gamma %s\n' "$*" >> "$TEST_LOG"
EOF
chmod +x "$scratch/bin/noctalia" "$XDG_CONFIG_HOME/scripts/gammashift.sh"
sed -i "1c#!$(command -v bash)" "$scratch/bin/noctalia" "$XDG_CONFIG_HOME/scripts/gammashift.sh"

dim="$repo/home/lynx/config/hypr/scripts/idle-dim.sh"
bash "$dim" locked
test ! -d "$XDG_RUNTIME_DIR/gammashift-idle"
bash "$dim" unlocked
test -d "$XDG_RUNTIME_DIR/gammashift-idle"
export TEST_LOCKED=true
bash "$dim" locked
test "$(grep -c '^gamma ' "$TEST_LOG")" = 2
bash "$dim" restore
test ! -d "$XDG_RUNTIME_DIR/gammashift-idle"
test "$(grep -c 'undo' "$TEST_LOG")" = 2
bash "$dim" restore
test "$(grep -c 'undo' "$TEST_LOG")" = 2

mkdir -p "$scratch/panic"
cp "$repo/home/lynx/config/hypr/scripts/panic/lock.sh" "$scratch/panic/"
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
bash "$repo/home/lynx/config/hypr/scripts/panic/panic.sh" -r

export HOME="$scratch/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$HOME/.dotfiles/.config/hypr/wallpapers" "$HOME/.dotfiles/.config/fish"
mkdir -p "$HOME/.dotfiles/.config/scripts" "$XDG_CONFIG_HOME" "$XDG_STATE_HOME/noctalia"
printf wallpaper > "$HOME/.dotfiles/.config/hypr/wallpapers/test.jpg"
printf fish-state > "$HOME/.dotfiles/.config/fish/fish_variables"
printf helper > "$HOME/.dotfiles/.config/scripts/unrelated.sh"
ln -s "$HOME/.dotfiles/.config/hypr" "$XDG_CONFIG_HOME/hypr"
ln -s "$HOME/.dotfiles/.config/fish" "$XDG_CONFIG_HOME/fish"
ln -s "$HOME/.dotfiles/.config/scripts" "$XDG_CONFIG_HOME/scripts"
printf override > "$XDG_STATE_HOME/noctalia/settings.toml"
bash "$repo/scripts/prepare-home-manager.sh"
test ! -L "$XDG_CONFIG_HOME/hypr"
test -f "$HOME/Personal/Pictures/wallpapers/test.jpg"
test "$(cat "$XDG_CONFIG_HOME/fish/fish_variables")" = fish-state
test -L "$XDG_CONFIG_HOME/scripts/unrelated.sh"
test -f "$XDG_STATE_HOME/home-manager-migration/noctalia-settings.toml"
test ! -e "$XDG_STATE_HOME/noctalia/settings.toml"
test -L "$XDG_STATE_HOME/home-manager-migration/hypr"
test -d "$HOME/.dotfiles/.config/hypr"
bash "$repo/scripts/prepare-home-manager.sh"

echo "Desktop script tests passed"

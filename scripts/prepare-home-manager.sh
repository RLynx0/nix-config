#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

config="${XDG_CONFIG_HOME:-"$HOME/.config"}"
state="${XDG_STATE_HOME:-"$HOME/.local/state"}"
backup="$state/home-manager-migration"
dotfiles="$(realpath "$HOME/.dotfiles")"
mkdir -p "$backup"

detach() {
    local path="$1" name="$2" target
    if [ ! -L "$path" ]; then
        return
    fi
    target="$(realpath "$path")"
    case "$target" in
        "$dotfiles"/*) ;;
        *) echo "Refusing to replace non-dotfiles symlink: $path" >&2; exit 1 ;;
    esac
    if [ -e "$backup/$name" ] || [ -L "$backup/$name" ]; then
        echo "Backup already exists: $backup/$name" >&2
        exit 1
    fi
    ln -s "$target" "$backup/$name"
    unlink "$path"
}

# Keep wallpapers and mutable Fish state out of the Nix store.
if [ -d "$config/hypr/wallpapers" ]; then
    mkdir -p "$HOME/Personal/Pictures/wallpapers"
    cp -an "$config/hypr/wallpapers/." "$HOME/Personal/Pictures/wallpapers/"
fi
if [ -f "$config/fish/fish_variables" ] && [ ! -f "$backup/fish_variables" ]; then
    cp "$config/fish/fish_variables" "$backup/fish_variables"
fi

for name in hypr fish kitty helix zellij bat cava direnv wlogout wofi waybar waypaper mako; do
    detach "$config/$name" "$name"
done
detach "$config/starship.toml" starship.toml

# Leave unrelated scripts available while handing the migrated files to HM.
if [ -L "$config/scripts" ]; then
    source_scripts="$(realpath "$config/scripts")"
    detach "$config/scripts" scripts
    mkdir -p "$config/scripts"
    for file in "$source_scripts"/*; do
        case "$(basename "$file")" in
            gammashift.sh|librewolf-workspace.sh|clipboard.sh) continue ;;
        esac
        ln -s "$file" "$config/scripts/$(basename "$file")"
    done
fi

mkdir -p "$config/fish"
if [ -f "$backup/fish_variables" ] && [ ! -f "$config/fish/fish_variables" ]; then
    cp "$backup/fish_variables" "$config/fish/fish_variables"
fi

if [ -f "$state/noctalia/settings.toml" ]; then
    if [ -e "$backup/noctalia-settings.toml" ]; then
        echo "Noctalia state backup already exists; refusing to overwrite it" >&2
        exit 1
    fi
    mv "$state/noctalia/settings.toml" "$backup/noctalia-settings.toml"
fi

printf 'Prepared Home Manager paths; rollback copies are in %s\n' "$backup"

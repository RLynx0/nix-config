# NixOS and Home Manager

`lynx-laptop` uses NixOS for Hyprland/UWSM, portals, PipeWire, NetworkManager,
Bluetooth, UPower, power profiles, fingerprint authentication and GNOME Keyring.
Home Manager owns Noctalia, the existing Hyprland Lua configuration, desktop
helpers, Fish, Starship, Kitty, Helix, Zellij, Bat, Cava and Direnv.

## First cutover from Stow

Build before changing any live configuration:

```sh
nix flake check
nixos-rebuild build --flake .#lynx-laptop
```

Then, from this repository:

```sh
bash scripts/prepare-home-manager.sh
sudo nixos-rebuild test --flake .#lynx-laptop
```

The preparation script detaches only symlinks pointing into `~/.dotfiles`,
keeps their absolute targets in `~/.local/state/home-manager-migration`, copies
wallpapers into `~/Personal/Pictures/wallpapers`, preserves Fish's mutable
universal variables, and backs up Noctalia's runtime settings. Existing dotfiles
are retained for rollback; their migrated paths must remain ignored by Stow.
The corresponding `.stow-local-ignore` change is in the dotfiles repository.

Log out and select **Hyprland (UWSM)** in GDM. Check `systemctl --user status
noctalia easyeffects wl-gammarelay`, then test launcher, session panel, clipboard,
audio, brightness, screenshots and lock/unlock with a TTY available. Reboot and
check clipboard history persistence. GNOME Keyring's default collection must
be unlocked; password login unlocks the login keyring, fingerprint-only login
may still require its password.

After the checks:

```sh
sudo nixos-rebuild switch --flake .#lynx-laptop
```

For rollback, select the previous NixOS generation and replace the generated
configuration paths with symlinks to the absolute targets saved under
`~/.local/state/home-manager-migration`. Restore `noctalia-settings.toml` to
`~/.local/state/noctalia/settings.toml` and undo the Stow ignore change.
Do not rerun preparation on already Home Manager-managed paths.

## Desktop controls

| Binding | Noctalia action |
| --- | --- |
| MOD+Q | Session panel |
| MOD+R | Application launcher |
| MOD+CTRL+C | Clipboard history |
| MOD+CTRL+E | Emoji launcher |
| MOD+CTRL+L | Lock |
| MOD+CTRL+ALT+L | Panic, lock, restore on unlock |
| MOD+I | Caffeine toggle |
| MOD+CTRL+S / W | Region / focused-output screenshot, both copied and saved |
| MOD+CTRL+B | Toggle bars |
| MOD+CTRL+H | Random wallpaper |
| MOD+N / MOD+ALT+N | Dismiss notifications / open notification history |
| MOD+CTRL+R | Restart Noctalia, EasyEffects and gamma relay |

Volume, brightness and media keys use `noctalia msg`, not brightnessctl,
wpctl or playerctl. Noctalia's overdrive ceiling is **150%**, rather than the
old wpctl limit of 125%. Clipboard deletion and emoji copy/type choices now
live in Noctalia's UI; the redundant CTRL+ALT clipboard/emoji/screenshot binds
are removed.

Noctalia replaces wofi, wlogout, cliphist, wl-clip-persist, rofimoji, grimblast,
hypridle, hyprlock, pavucontrol and Blueman. Keep `wl-clipboard`, `hyprpicker`,
`dex`, `libnotify`, `calc` and `wl-gammarelay-rs` for remaining functionality.
Panic's per-player pause/resume uses MPRIS over `busctl`, since Noctalia's media
IPC controls the selected player rather than every player.

## Scripting and settings

Examples:

```sh
noctalia msg panel-toggle session
noctalia msg panel-open launcher /emo
noctalia msg panel-toggle clipboard
noctalia msg volume-up 5
noctalia msg brightness-down eDP-1 5
noctalia msg media toggle
noctalia msg caffeine-toggle
noctalia msg status
printf 'one\ntwo\n' | noctalia dmenu -p 'Choose'
```

Use `noctalia msg --help` for the pinned version's complete IPC list, including
screenshots, microphone, wallpaper, network, Bluetooth, power, notifications,
DPMS and runtime config commands. The pinned upstream package supports
per-call screenshot copy/save flags as well as the configured defaults.

Declarative settings are in `home/lynx/noctalia.nix`, validated at build time.
Noctalia GUI/IPC changes write `~/.local/state/noctalia/settings.toml`, which
**overrides** the generated config. Carry wanted changes into Nix and move aside
the state file when returning to the declarative configuration.

Noctalia themes itself from wallpaper, but its app templates are disabled.
Existing custom app themes are retained; Stylix still handles other targets.
Noctalia nightlight is disabled because `wl-gammarelay-rs` owns gamma control.
Idle behavior preserves dimming, locks after 160 seconds, turns screens off
after 180 seconds and locks/suspends after 1800 seconds.

The upstream `cachix` input deliberately does not follow the system's nixpkgs,
so its binary cache can be used. The configured cache becomes available to
the Nix daemon after system activation; an initial build may compile Noctalia.

Sources: [Noctalia NixOS installation](https://docs.noctalia.dev/noctalia/getting-started/nixos/),
[Noctalia documentation](https://docs.noctalia.dev/noctalia/),
[Hyprland NixOS](https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/).

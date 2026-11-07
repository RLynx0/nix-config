# NixOS and Home Manager

`lynx-laptop` uses NixOS for Hyprland/UWSM, portals, PipeWire, NetworkManager,
Bluetooth, UPower, power profiles, fingerprint authentication and GNOME Keyring.
Home Manager owns Noctalia, the existing Hyprland Lua configuration, desktop
helpers, Fish, Starship, Kitty, Helix, Zellij, Bat, Cava and Direnv.

## Applying and validating changes

Build before changing any live configuration:

```sh
nix flake check
nixos-rebuild build --flake .#lynx-laptop
```

Home Manager-managed paths must remain ignored by Stow in `~/.dotfiles`.

For the GDM-to-greetd cutover, **do not activate with `test` or `switch` inside
the graphical session**: stopping the old display manager can end that session.
Prepare the next boot instead:

```sh
sudo nixos-rebuild boot --flake .#lynx-laptop
sudo reboot
```

Keep the previous generation in the boot menu and a TTY (Ctrl+Alt+F3) available.
Noctalia Greeter defaults to **Hyprland (uwsm-managed)** and password login.
Its PAM stack unlocks GNOME Keyring; fingerprint remains enabled for the lock
screen, not for the greeter.

Check `systemctl --user status noctalia easyeffects wl-gammarelay`,
then test launcher, session panel, clipboard,
audio, brightness, screenshots and lock/unlock with a TTY available. Reboot and
check clipboard history persistence. GNOME Keyring's default collection must
be unlocked; password login unlocks the login keyring, fingerprint-only login
may still require its password.

For subsequent changes that do not replace the display manager, test before
switching permanently:

```sh
sudo nixos-rebuild test --flake .#lynx-laptop
sudo nixos-rebuild switch --flake .#lynx-laptop
```

For rollback, select the previous NixOS generation.

User environment variables, XDG paths and extra PATH entries are configured in
`home/lynx/environment.nix`. Fish aliases and functions are in
`home/lynx/programs.nix`.

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

Declarative settings are in `home/lynx/noctalia.toml`, validated at build time.
`home/lynx/noctalia.nix` installs Noctalia and its generated logo asset.
Noctalia GUI/IPC changes write `~/.local/state/noctalia/settings.toml`, which
**overrides** the repository config. To capture subsequent GUI changes:

```sh
noctalia config export merged --credentials omit > home/lynx/noctalia.toml
```

Review the export for secrets before committing it, then build and activate.
Once activated, stop Noctalia, move the runtime `settings.toml` to a backup
outside its config directory, and start Noctalia again. Do not remove runtime
overrides before capturing them. The logo uses the stable Home Manager path
`~/.config/noctalia/assets/lynx-lock-logo.png`, rather than an exported store path.

Noctalia themes itself from wallpaper, but its app templates are disabled.
Existing custom app themes are retained; Stylix still handles other targets.
Noctalia nightlight is disabled because `wl-gammarelay-rs` owns gamma control.
Idle dims brightness to one third and raises gamma over **1.5 seconds** at
150 seconds, locks at 160 seconds, turns screens off at 180 seconds, and
locks/suspends at 1800 seconds. An already-locked session dims after 20 seconds
and turns screens off after 30 seconds. Activity restores gamma/brightness
over 0.3 seconds. Noctalia's default pre-action black overlay is disabled;
locked-only timers use `locked_timeout`, not guards inside scripts.

The native lock screen uses a darkened blurred wallpaper, a large clock/date,
circular Lynx logo, username and compact password row. Layouts are declared
for eDP-1 (1128x752 logical pixels) and HDMI-A-1 (1920x1080); other outputs retain
Noctalia's default login box. The old weather cache and uptime label are omitted.
The one-second passwordless grace window matches the old hyprlock setting;
set `lockscreen.grace_period_seconds = 0` to require authentication immediately.

Noctalia Greeter runs under greetd with its own compositor. It shares Noctalia's
wallpaper, palette, font and monitor settings, not the lock-screen widget layout.
The greeter has a large clock but no custom Lynx logo or background blur.
After the first boot, run `noctalia msg greeter-sync` once; subsequent appearance
changes sync automatically. Only the constrained appearance-sync helper is
authorized without a password for the active local `lynx` session. The greeter
settings and cursor remain declarative in `nixos/desktop.nix`.

The upstream `cachix` input deliberately does not follow the system's nixpkgs,
so its binary cache can be used. The configured cache becomes available to
the Nix daemon after system activation; an initial build may compile Noctalia.

Sources: [Noctalia NixOS installation](https://docs.noctalia.dev/noctalia/getting-started/nixos/),
[Noctalia documentation](https://docs.noctalia.dev/noctalia/),
[Hyprland NixOS](https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/).

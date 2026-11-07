# NixOS and Home Manager

`lynx-laptop` uses NixOS for Hyprland/UWSM, portals, PipeWire, NetworkManager,
Bluetooth, UPower, power profiles, fingerprint authentication and GNOME Keyring.
Home Manager owns Noctalia, the existing Hyprland Lua configuration, desktop
helpers, Fish, Starship, Kitty, Helix, Zellij, Bat, Cava and Direnv.

## Module layout

This flake uses the [dendritic pattern](https://github.com/mightyiam/dendritic),
inspired by [vimjoyer/nixconf](https://github.com/vimjoyer/nixconf). `flake.nix`
contains inputs and the entry point; `import-tree` loads all Nix files under
`modules/` as **flake-parts modules**, not directly as NixOS/HM modules.

| Path | Responsibility |
| --- | --- |
| `modules/flake/` | Module registry, shared `meta`, systems, formatter and dev shell |
| `modules/hosts/lynx-laptop/` | Host composition and generated hardware configuration |
| `modules/base/` | Nix settings, locale, bootloader, networking, user and HM integration |
| `modules/desktop/` | Hyprland/UWSM, Noctalia, greeter, audio, fonts, Stylix, cursor, keyboard, authentication and file manager |
| `modules/hardware/` | AMD GPU/LACT, Bluetooth, eGPU sleep inhibitor and printing |
| `modules/shell/`, `terminal/`, `editor/`, `cava.nix` | Home Manager programs and environment |
| `modules/packages/` | CLI tools, language servers, apps, creative tools and gaming |

Features publish named modules under `flake.modules.nixos.<name>` and
`flake.modules.homeManager.<name>`. Hosts compose them by name; `base` and
`desktop` are bundles of features that belong together. Multiple files can
contribute to the same module (for example Fish, environment and shell tools
merge into `shell`). Importing a feature enables it; no custom enable switches
or `specialArgs` plumbing are required.

For example, a feature with both system and user configuration looks like:

```nix
# modules/example.nix
{ config, ... }:
{
  flake.modules.nixos.example = {
    home-manager.sharedModules = [ config.flake.modules.homeManager.example ];
    # NixOS settings here.
  };
  flake.modules.homeManager.example = {
    # Home Manager settings here.
  };
}
```

Add `example` to a host's `imports = with config.flake.modules.nixos; [ ... ];`.
The NixOS side attaches its HM counterpart to every managed user on that host;
user-specific settings belong in `home-manager.users.<name>` instead.
Import `homeManager` and `stylix` when using the existing user features.
Within this flake, reference modules as `config.flake.modules.nixos.example`;
from another flake, use `inputs.<name>.modules.nixos.example` or
`inputs.<name>.modules.homeManager.example`.

Keep raw config files next to their owning feature. `_`-prefixed paths are
excluded from automatic imports, useful for ordinary Nix expressions that
are not flake-parts modules. A new host follows `configuration.nix`: expose
its named NixOS module, compose features and hardware, and feed it to
`nixpkgs.lib.nixosSystem`. Host and home `stateVersion` values are deliberately
unchanged; do not bump them as part of a refactor.

Shared username, keyboard layout and cursor settings live in
`modules/flake/meta.nix`. When an inner module needs its own `config`, alias
the outer argument or capture shared values before entering it. Hyprland's
raw Lua still declares `kb_layout = "at"` in
`modules/desktop/hyprland/config/hyprland/input.lua`; update that too if changing
the layout. The Bibata package is selected in the cursor and greeter modules.

The nixpkgs registry and `NIX_PATH` already follow the flake input through
NixOS's defaults. `system.configurationRevision` records the repository
revision (with a dirty marker for uncommitted changes).

```sh
nix fmt
nix develop
# Inside the dev shell:
statix check .
deadnix .
```

The dev shell supplies nixfmt, nil, statix and deadnix. Lints are available
on demand, not enforced as flake checks. `nix flake check` includes
`checks.<linux-system>.hyprland`, testing idle/panic scripts and verifying the
Lua configuration. Its script is in `modules/desktop/hyprland/tests/`.
Nix currently warns that the exported `modules` output is unknown; this is
expected for flake-parts' typed module registry.
The flake targets `x86_64-linux` and `aarch64-linux`; Darwin outputs are omitted.
Use `nix flake check --all-systems --no-build` to evaluate both Linux targets.

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
`modules/shell/environment.nix`. Fish aliases and functions are in
`modules/shell/fish.nix`.

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

Declarative settings are in `modules/desktop/noctalia/noctalia.toml`, validated
at build time. `modules/desktop/noctalia/noctalia.nix` installs Noctalia and
its generated logo asset.
Noctalia GUI/IPC changes write `~/.local/state/noctalia/settings.toml`, which
**overrides** the repository config. To capture subsequent GUI changes:

```sh
noctalia config export merged --credentials omit > modules/desktop/noctalia/noctalia.toml
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
settings and cursor remain declarative in `modules/desktop/greeter.nix`.

The upstream `cachix` input deliberately does not follow the system's nixpkgs,
so its binary cache can be used. The configured cache becomes available to
the Nix daemon after system activation; an initial build may compile Noctalia.

Sources: [Noctalia NixOS installation](https://docs.noctalia.dev/noctalia/getting-started/nixos/),
[Noctalia documentation](https://docs.noctalia.dev/noctalia/),
[Hyprland NixOS](https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/).

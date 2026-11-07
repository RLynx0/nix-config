{ config, lib, ... }:
{
  imports = [
    ./noctalia.nix
    ./hyprland.nix
    ./programs.nix
  ];
  home.stateVersion = "25.11";

  home.activation.checkStowConflicts = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    dotfiles="$(readlink -f "${config.home.homeDirectory}/.dotfiles")"
    for name in hypr fish kitty helix zellij bat cava direnv scripts starship.toml; do
      path="${config.xdg.configHome}/$name"
      if [ -L "$path" ]; then
        case "$(readlink -f "$path")" in
          "$dotfiles"/*)
            echo "Home Manager would write through the Stow symlink: $path" >&2
            echo "Run scripts/prepare-home-manager.sh from ~/.nix-config first." >&2
            exit 1
            ;;
        esac
      fi
    done
  '';
}

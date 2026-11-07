{ config, ... }:
{
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.hyprland ];
    services.displayManager.defaultSession = "hyprland-uwsm";
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };

  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      configType = "lua";
      systemd.enable = false;
      extraConfig = builtins.readFile ./config/hyprland.lua;
    };

    xdg.configFile = {
      "hypr/hyprland" = {
        source = ./config/hyprland;
        recursive = true;
      };
      "hypr/scripts" = {
        source = ./config/scripts;
        recursive = true;
      };
      "scripts/librewolf-workspace.sh".source = ./config/helpers/librewolf-workspace.sh;
      "uwsm/env".text = ''
        export GDK_BACKEND=wayland
        export QT_QPA_PLATFORM='wayland;xcb'
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export OZONE_PLATFORM=wayland
        export XCURSOR_THEME=${config.meta.cursor.name}
        export XCURSOR_SIZE=${toString config.meta.cursor.size}
      '';
    };

    home.packages = with pkgs; [
      calc
      dex
      hyprpicker
      libnotify
      wl-clipboard
    ];

    stylix.targets.hyprland.enable = false;
  };
}

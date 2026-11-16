{ config, ... }:
{
  flake.modules.nixos.hyprland = { pkgs, lib, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.hyprland ];
    services.displayManager.defaultSession = "hyprland-uwsm";
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    # D-Bus activation during logout can otherwise start a portal without a compositor,
    # leaving a stale frontend that advertises no ScreenCast sources in the next session.
    systemd.user.services =
      lib.genAttrs
        [
          "xdg-desktop-portal"
          "xdg-desktop-portal-hyprland"
        ]
        (_: {
          after = [ "graphical-session.target" ];
          requisite = [ "graphical-session.target" ];
        });
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
      dex
      hyprpicker
      libnotify
      wl-clipboard
    ];

    stylix.targets.hyprland.enable = false;
  };
}

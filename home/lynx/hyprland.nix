{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd.enable = false;
    extraConfig = builtins.readFile ./config/hypr/hyprland.lua;
  };

  xdg.configFile = {
    "hypr/hyprland" = {
      source = ./config/hypr/hyprland;
      recursive = true;
    };
    "hypr/scripts" = {
      source = ./config/hypr/scripts;
      recursive = true;
    };
    "scripts/gammashift.sh".source = ./config/scripts/gammashift.sh;
    "scripts/librewolf-workspace.sh".source = ./config/scripts/librewolf-workspace.sh;
    "uwsm/env".text = ''
      export GDK_BACKEND=wayland
      export QT_QPA_PLATFORM='wayland;xcb'
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export OZONE_PLATFORM=wayland
      export XCURSOR_THEME=Bibata-Modern-Classic
      export XCURSOR_SIZE=24
    '';
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    calc
    dex
    hyprpicker
    libnotify
    wl-clipboard
    wl-gammarelay-rs
  ];

  services.easyeffects.enable = true;
  systemd.user.services.wl-gammarelay = {
    Unit = {
      Description = "Gamma control for gammashift";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };
    Service = {
      ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
      Restart = "on-failure";
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}

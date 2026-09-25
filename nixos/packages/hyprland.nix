{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awww
    baobab
    calc
    dex
    grimblast
    hypridle
    hyprlock
    hyprpicker
    inotify-tools
    libnotify
    mako
    pavucontrol
    rofimoji
    waybar
    waypaper
    wl-gammarelay-rs
    wlogout
    wofi
  ];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];
}

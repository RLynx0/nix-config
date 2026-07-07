{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awww
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
    thunar
    waybar
    waypaper
    wl-gammarelay-rs
    wlogout
    wofi
  ];
}

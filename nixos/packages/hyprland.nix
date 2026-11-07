{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awww
    baobab
    brightnessctl
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
    noctalia
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

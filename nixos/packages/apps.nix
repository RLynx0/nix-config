{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    kdePackages.gwenview
    kdePackages.kdenlive
    libreoffice
    obs-studio
    obsidian
    spotify
    thunderbird
    vlc
  ];
}

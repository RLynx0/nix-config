{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    kdePackages.gwenview
    kdePackages.kdenlive
    libdvdcss
    libreoffice
    obs-studio
    obsidian
    spotify
    thunderbird
    vlc
  ];
}

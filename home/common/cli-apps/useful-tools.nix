{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    bc
    calc
    entr
    espeak
    gh
    git-filter-repo
    htop
    jq
    libnotify
    tldr
    tree
    xdg-ninja
  ];
}

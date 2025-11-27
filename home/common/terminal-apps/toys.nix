{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cava
    cbonsai
    cmatrix
    cowsay
    fortune
    lolcat
    fastfetch
    sl
  ];
}

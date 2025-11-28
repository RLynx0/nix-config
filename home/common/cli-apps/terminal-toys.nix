{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cava
    cbonsai
    cowsay
    fastfetch
    fortune
    lolcat
    unimatrix
    sl
  ];
}

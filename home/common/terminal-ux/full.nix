{ pkgs, ... }:

{
  imports = [
    ./helix/full.nix
  ];

  home.packages = with pkgs; [
    fzf
    lazygit
    starship
    zellij
    zoxide
  ];
}

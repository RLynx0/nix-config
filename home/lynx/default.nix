{ pkgs, ... }:
{
  # Home Manager configuration for the lynx user.
  # See https://nix-community.github.io/home-manager/options.xhtml for all options.

  home.stateVersion = "25.11";

  # home.packages = with pkgs; [ ];

  # programs.git = {
  #   enable = true;
  #   userName = "Lynx";
  #   userEmail = "your@email.com";
  # };

  # programs.fish = {
  #   enable = true;
  #   shellAliases = { };
  # };
}

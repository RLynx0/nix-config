{ ... }:
{
  imports = [
    ./environment.nix
    ./noctalia.nix
    ./hyprland.nix
    ./programs.nix
  ];
  home.stateVersion = "25.11";
}

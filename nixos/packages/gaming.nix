{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    azahar
    bottles
    dolphin-emu
    gopher64
    lutris
    protonup-ng
  ];

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];
}

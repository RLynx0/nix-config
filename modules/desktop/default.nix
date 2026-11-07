{ config, ... }:
{
  flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
    hyprland
    noctalia
    greeter
    audio
    fonts
    stylix
    cursor
    keyboard
    auth
    fileManager
  ];
}

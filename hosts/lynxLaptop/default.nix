{ ... }:
{
  imports = [
    ./hardware.nix
    ../../nixos/core.nix
    ../../nixos/locale.nix
    ../../nixos/boot.nix
    ../../nixos/networking.nix
    ../../nixos/desktop.nix
    ../../nixos/audio.nix
    ../../nixos/hardware.nix
    ../../nixos/services.nix
    ../../nixos/fonts.nix
    ../../nixos/users/lynx.nix
    ../../nixos/packages/system.nix
    ../../nixos/packages/apps.nix
    ../../nixos/packages/creative.nix
    ../../nixos/packages/lsps.nix
    ../../nixos/packages/hyprland.nix
    ../../nixos/packages/gaming.nix
  ];

  networking.hostName = "lynx-laptop";
  system.stateVersion = "26.05";
}

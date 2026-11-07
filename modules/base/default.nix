{ config, ... }:
{
  flake.modules.nixos.base = {
    imports = with config.flake.modules.nixos; [
      nix
      locale
      boot
      networking
      users
      homeManager
    ];
  };
}

{ config, ... }:
{
  flake.modules.nixos.nix = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    environment.defaultPackages = [ ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ config.flake.overlays.default ];
  };
}

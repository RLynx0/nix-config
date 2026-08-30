{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.defaultPackages = [ ];

  nixpkgs.config.allowUnfree = true;
}

{
  config,
  inputs,
  lib,
  ...
}:
{
  flake.overlays.default =
    final: _prev:
    lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ../../pkgs;
    };

  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system}.extend config.flake.overlays.default;
    in
    {
      _module.args.pkgs = pkgs;
      packages = lib.mapAttrs (name: _: pkgs.${name}) (config.flake.overlays.default pkgs pkgs);
    };
}

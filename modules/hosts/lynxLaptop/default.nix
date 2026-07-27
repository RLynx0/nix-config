{ inputs, ... }:

{
  flake.nixosConfigurations.lynx-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../../../hosts/lynxLaptop/default.nix
      # Workaround: lact-0.9.1 requires libdisplay-info < 0.4.0, but nixpkgs-unstable
      # bumped it to 0.4.0. Use the version from nixpkgs-stable (0.3.x) until fixed upstream.
      (_final: {
        nixpkgs.overlays = [
          (_: prev: {
            lact = prev.lact.override {
              libdisplay-info =
                inputs.nixkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.libdisplay-info;
            };
          })
        ];
      })
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.lynx = import ../../../home/lynx/default.nix;
      }
      # Uncomment to activate Stylix theming (also uncomment stylix/default.nix body):
      # inputs.stylix.nixosModules.stylix
      # (import ../../../stylix/default.nix)
    ];
  };
}

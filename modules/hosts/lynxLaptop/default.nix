{ inputs, ... }:

{
  flake.nixosConfigurations.lynx-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../../../hosts/lynxLaptop/default.nix
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

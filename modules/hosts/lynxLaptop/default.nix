{ self, inputs, ... }: {

  flake.nixosConfigurations.lynx-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.lynxLaptopConfiguration
    ];
  };

}

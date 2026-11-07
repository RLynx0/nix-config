{ inputs, config, ... }:
{
  flake.nixosConfigurations.lynx-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.hostLynxLaptop ];
  };

  flake.modules.nixos.hostLynxLaptop = {
    imports = with config.flake.modules.nixos; [
      hostLynxLaptopHardware
      base
      desktop
      amdGpu
      bluetooth
      egpu
      printing
      shell
      kitty
      helix
      zellij
      cava
      cliTools
      apps
      creative
      lsps
      gaming
    ];

    networking.hostName = "lynx-laptop";
    system.stateVersion = "26.05";
    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };
}

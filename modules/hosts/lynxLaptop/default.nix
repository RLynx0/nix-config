{ self, inputs, ... }:

{
  flake.nixosModules = {
    hostLynx = inputs.self + /hosts/lynxLaptop/default.nix;
    hostLynxHardware = inputs.self + /hosts/lynxLaptop/hardware.nix;

    core = inputs.self + /nixos/core.nix;
    locale = inputs.self + /nixos/locale.nix;
    boot = inputs.self + /nixos/boot.nix;
    networking = inputs.self + /nixos/networking.nix;
    desktop = inputs.self + /nixos/desktop.nix;
    audio = inputs.self + /nixos/audio.nix;
    hardware = inputs.self + /nixos/hardware.nix;
    services = inputs.self + /nixos/services.nix;
    fonts = inputs.self + /nixos/fonts.nix;

    userLynx = inputs.self + /nixos/users/lynx.nix;
    homeManagerLynx = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.lynx = import (inputs.self + /home/lynx/default.nix);
    };

    packagesSystem = inputs.self + /nixos/packages/system.nix;
    packagesApps = inputs.self + /nixos/packages/apps.nix;
    packagesCreative = inputs.self + /nixos/packages/creative.nix;
    packagesLsps = inputs.self + /nixos/packages/lsps.nix;
    packagesHyprland = inputs.self + /nixos/packages/hyprland.nix;
    packagesGaming = inputs.self + /nixos/packages/gaming.nix;

    stylixLynx = inputs.self + /stylix/default.nix;
  };

  flake.nixosModules.lynxLaptopConfiguration = {
    imports = [
      self.nixosModules.hostLynxHardware
      self.nixosModules.hostLynx
      self.nixosModules.core
      self.nixosModules.locale
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.desktop
      self.nixosModules.audio
      self.nixosModules.hardware
      self.nixosModules.services
      self.nixosModules.fonts
      self.nixosModules.userLynx
      self.nixosModules.packagesSystem
      self.nixosModules.packagesApps
      self.nixosModules.packagesCreative
      self.nixosModules.packagesLsps
      self.nixosModules.packagesHyprland
      self.nixosModules.packagesGaming

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
      self.nixosModules.homeManagerLynx
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixLynx
    ];
  };

  flake.nixosConfigurations.lynx-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.lynxLaptopConfiguration
    ];
  };
}

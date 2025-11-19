{
  description = "RLynx_' Nix configuration";

  inputs = {
    # -- Official Nixpkgs Channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # -- Community Modules
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... }@inputs:
    let

      system = "x86-64-linux";
      custom_lib = import ./lib { inherit (nixpkgs) lib; };
      lib = nixpkgs.lib.extend (self: super: { custom = custom_lib; });

    in {

      nixosConfigurations = let

        specialArgs = { inherit system inputs lib; };
        nixos_hosts = builtins.attrNames (builtins.readDir ./hosts/nixos);

      in builtins.listToAttrs (map (host: {
        name = host;
        value = lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/nixos/${host} ];
        };
      }) nixos_hosts);

    };
}

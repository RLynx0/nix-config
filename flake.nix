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

    stylix.url = "github:danth/stylix";
  };

  outputs =
    { nixpkgs, ... }@inputs:

    let
      system = "x86_64-linux";
      custom_lib = import ./lib { inherit (nixpkgs) lib; };
      lib = nixpkgs.lib.extend (self: super: { custom = custom_lib; });
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
    in
    {

      nixosConfigurations =
        let
          nixos_hosts = builtins.attrNames (builtins.readDir ./hosts/nixos);
          specialArgs = { inherit lib inputs system pkgs-unstable; };
        in

        builtins.listToAttrs (
          map (host: {
            name = host;
            value = lib.nixosSystem {
              inherit system specialArgs;
              modules = [ ./hosts/nixos/${host} ];
            };
          }) nixos_hosts
        );

    };
}

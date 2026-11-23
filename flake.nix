{
  inputs = {
    # -- Official Nixpkgs Channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixkgs-stable.url = "github:nixos/nixpkgs/25.11";

    # -- Community Modules
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Includes configurable clock sizes, which the 1.7.0 release does not yet support.
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter/effcb9ffc33f7120cbc6cfc6c6527e9da763a0e9";
    noctalia-greeter.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

  };

  # import modules/ automatically
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}

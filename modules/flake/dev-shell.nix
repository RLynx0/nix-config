{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        nixfmt
        nil
        statix
        deadnix
      ];
    };
  };
}

{ inputs, ... }:
{
  flake.modules.nixos.stylix = { pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    # Stylix theming configuration.
    # See https://stylix.danth.me/ for all options.

    stylix.enable = true;
    stylix.image = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
    stylix.base16Scheme = ./lynx.yaml;
    stylix.polarity = "dark";

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.caskaydia-cove;
        name = "CaskaydiaCove Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.corefonts;
        name = "Helvetica";
      };
    };

  };
}

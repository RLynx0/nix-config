{ pkgs, ... }:
{
  # Stylix theming configuration.
  # See https://stylix.danth.me/ for all options.
  #
  # To activate, uncomment the stylix input in modules/hosts/lynxLaptop/default.nix.

  # stylix.enable = true;
  # stylix.image = ./wallpaper.png;
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  # stylix.polarity = "dark";

  # stylix.fonts = {
  #   monospace = {
  #     package = pkgs.nerd-fonts.caskaydia-cove;
  #     name = "CaskaydiaCove Nerd Font Mono";
  #   };
  #   sansSerif = {
  #     package = pkgs.nerd-fonts.meslo-lg;
  #     name = "MesloLGS Nerd Font";
  #   };
  # };

  # stylix.targets = {
  #   hyprland.enable = true;
  #   waybar.enable = true;
  #   kitty.enable = true;
  # };
}

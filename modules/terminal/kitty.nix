{ config, ... }:
{
  flake.modules.nixos.kitty.home-manager.sharedModules = [
    config.flake.modules.homeManager.kitty
  ];
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      enable = true;
      shellIntegration.mode = "no-cursor";
      extraConfig = builtins.readFile ./kitty/kitty.conf;
    };
    xdg.configFile."kitty/sessions".source = ./kitty/sessions;
    stylix.targets.kitty.enable = false;
  };
}

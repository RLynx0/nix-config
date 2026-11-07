{ config, ... }:
{
  flake.modules.nixos.zellij.home-manager.sharedModules = [
    config.flake.modules.homeManager.zellij
  ];
  flake.modules.homeManager.zellij = {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
      enableBashIntegration = false;
      enableZshIntegration = false;
      extraConfig = builtins.readFile ./zellij/config.kdl;
    };
    xdg.configFile."zellij/themes" = {
      source = ./zellij/themes;
      recursive = true;
    };
    stylix.targets.zellij.enable = false;
  };
}

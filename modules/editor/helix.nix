{ config, ... }:
{
  flake.modules.nixos.helix.home-manager.sharedModules = [
    config.flake.modules.homeManager.helix
  ];
  flake.modules.homeManager.helix = {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      extraConfig = builtins.readFile ./helix/config.toml;
    };
    xdg.configFile = {
      "helix/languages.toml".source = ./helix/languages.toml;
      "helix/themes" = {
        source = ./helix/themes;
        recursive = true;
      };
    };
    stylix.targets.helix.enable = false;
  };
}

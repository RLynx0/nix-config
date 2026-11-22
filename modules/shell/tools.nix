{
  flake.modules.homeManager.shell = {
    programs = {
      starship = {
        enable = true;
        enableTransience = true;
      };
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };
      bat = {
        enable = true;
        config.theme = "Dark Lynx";
        themes."Dark Lynx" = {
          src = ./bat/themes/dark-lynx;
          file = "Dark Lynx.tmTheme";
        };
      };
      lsd = {
        enable = true;
        enableFishIntegration = true;
      };
    };
    xdg.configFile."starship.toml".source = ./starship.toml;
    stylix.targets = {
      bat.enable = false;
      starship.enable = false;
    };
  };
}

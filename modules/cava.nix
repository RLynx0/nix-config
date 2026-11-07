{ config, ... }:
{
  flake.modules.nixos.cava.home-manager.sharedModules = [
    config.flake.modules.homeManager.cava
  ];
  flake.modules.homeManager.cava = {
    programs.cava = {
      enable = true;
      settings = {
        general = {
          framerate = 60;
          autosens = 1;
          overshoot = 10;
          bar_width = 2;
          bar_spacing = 1;
        };
        output = {
          method = "noncurses";
          channels = "stereo";
          mono_option = "average";
          reverse = 0;
        };
        color = {
          gradient = 1;
          gradient_count = 3;
          gradient_color_1 = "'#22eeff'";
          gradient_color_2 = "'#ee44ff'";
          gradient_color_3 = "'#ffffff'";
        };
        smoothing.gravity = 150;
      };
    };
    stylix.targets.cava.enable = false;
  };
}

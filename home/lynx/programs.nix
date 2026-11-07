{ ... }:
{
  programs = {
    fish = {
      enable = true;
      shellInit = builtins.readFile ./config/fish/config.fish;
    };
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
      config.log_format = "-";
    };
    kitty = {
      enable = true;
      extraConfig = builtins.readFile ./config/kitty/kitty.conf;
    };
    helix = {
      enable = true;
      extraConfig = builtins.readFile ./config/helix/config.toml;
    };
    zellij = {
      enable = true;
      enableFishIntegration = false;
      enableBashIntegration = false;
      enableZshIntegration = false;
      extraConfig = builtins.readFile ./config/zellij/config.kdl;
    };
    bat = {
      enable = true;
      config.theme = "Dark Lynx";
      themes."Dark Lynx" = {
        src = ./config/bat/themes/dark-lynx;
        file = "Dark Lynx.tmTheme";
      };
    };
    cava = {
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
  };

  xdg.configFile = {
    "starship.toml".source = ./config/starship.toml;
    "fish/conf.d" = {
      source = ./config/fish/conf.d;
      recursive = true;
    };
    "fish/completions" = {
      source = ./config/fish/completions;
      recursive = true;
    };
    "kitty/sessions" = {
      source = ./config/kitty/sessions;
      recursive = true;
    };
    "helix/languages.toml".source = ./config/helix/languages.toml;
    "helix/themes" = {
      source = ./config/helix/themes;
      recursive = true;
    };
    "zellij/themes" = {
      source = ./config/zellij/themes;
      recursive = true;
    };
  };

  # These applications retain their existing custom themes.
  stylix.targets = {
    bat.enable = false;
    cava.enable = false;
    fish.enable = false;
    helix.enable = false;
    hyprland.enable = false;
    kitty.enable = false;
    noctalia.enable = false;
    starship.enable = false;
    zellij.enable = false;
  };
}

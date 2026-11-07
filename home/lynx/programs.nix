{ config, ... }:
let
  notification = "${config.home.homeDirectory}/Personal/Music/sounds/martlet-bell.wav";
  alertImage = "${config.home.homeDirectory}/Personal/Pictures/renders/SuperSaiyanMartletSmol.gif";
in
{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        helix = "hx";
        bg-sysup = "sysup -cypa '${notification}' -i '${alertImage}'";
        rereflect = "rereflect -a '${notification}' -i '${alertImage}'";
        icat = "kitty +kitten icat";
        whats-my-motherfucking-name = "whoami";
      };
      functions = {
        fish_greeting = ''
          if command -vq souls.sh
              souls.sh -t darklynx m | awk '
                  BEGIN { print "" }
                  { print "  " $0 }
                  END { print "" }'
          else if command -vq neofetch
              echo
              neofetch | neofetch | grep --color=never -oxE '^.+$'
          end
        '';
        starship_transient_prompt_func = "starship module character";
      };
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
      silent = true;
    };
    kitty = {
      enable = true;
      shellIntegration.mode = "no-cursor";
      extraConfig = builtins.readFile ./config/kitty/kitty.conf;
    };
    helix = {
      enable = true;
      defaultEditor = true;
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

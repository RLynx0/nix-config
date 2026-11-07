{ config, ... }:
{
  flake.modules.nixos.shell = {
    programs.fish.enable = true;
    home-manager.sharedModules = [ config.flake.modules.homeManager.shell ];
  };
  flake.modules.homeManager.shell =
    { config, ... }:
    let
      notification = "${config.home.homeDirectory}/Personal/Music/sounds/martlet-bell.wav";
      alertImage = "${config.home.homeDirectory}/Personal/Pictures/renders/SuperSaiyanMartletSmol.gif";
    in
    {
      programs.fish = {
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
      xdg.configFile = {
        "fish/conf.d" = {
          source = ./fish/conf.d;
          recursive = true;
        };
        "fish/completions" = {
          source = ./fish/completions;
          recursive = true;
        };
      };
      stylix.targets.fish.enable = false;
    };
}

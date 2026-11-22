{ config, ... }:
{
  flake.modules.nixos.shell = {
    programs.fish.enable = true;
    home-manager.sharedModules = [ config.flake.modules.homeManager.shell ];
  };
  flake.modules.homeManager.shell =
    { ... }:
    {
      programs.fish = {
        enable = true;
        shellAliases = {
          helix = "hx";
          icat = "kitty +kitten icat";
          whats-my-motherfucking-name = "whoami";
        };
        functions = {
          fish_greeting = /*fish*/''
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
          starship_transient_prompt_func = /*fish*/''
            starship module character
          '';
        };
      };
      stylix.targets.fish.enable = false;
    };
}

{ inputs, config, ... }:
{
  flake.modules.nixos.noctalia = {
    imports = [ inputs.noctalia.nixosModules.default ];
    home-manager.sharedModules = [ config.flake.modules.homeManager.noctalia ];
    programs.noctalia = {
      enable = true;
      package = null;
      recommendedServices.enable = true;
    };
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };
  flake.modules.homeManager.noctalia =
    { pkgs, ... }:
    let
      lockLogo =
        pkgs.runCommand "lynx-lock-logo.png"
          {
            nativeBuildInputs = [ pkgs.imagemagick ];
          }
          ''
            magick ${./assets/lynx-logo.png} -resize '300x300^' -gravity center -extent 300x300 \
              \( -size 300x300 xc:none -fill white -draw 'circle 150,150 150,5' \) \
              -alpha off -compose CopyOpacity -composite \
              -compose Over -fill none -stroke '#444444' -strokewidth 5 \
              -draw 'circle 150,150 150,5' PNG:"$out"
          '';
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = ./noctalia.toml;
      };

      xdg.configFile."noctalia/assets/lynx-lock-logo.png".source = lockLogo;
      stylix.targets.noctalia.enable = false;
    };
}

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
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = ./noctalia.toml;
  };

  xdg.configFile."noctalia/assets/lynx-lock-logo.png".source = lockLogo;
}

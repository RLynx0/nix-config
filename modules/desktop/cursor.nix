{ config, ... }:
{
  flake.modules.nixos.cursor.home-manager.sharedModules = [
    config.flake.modules.homeManager.cursor
  ];
  flake.modules.homeManager.cursor = { pkgs, ... }: {
    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      inherit (config.meta.cursor) name size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}

{ inputs, config, ... }:
{
  flake.modules.nixos.greeter = { pkgs, ... }: {
    imports = [ inputs.noctalia-greeter.nixosModules.default ];
    services.xserver.enable = true;
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordless-sync-users = [ config.meta.username ];
      settings = {
        session.default = "Hyprland (uwsm-managed)";
        user.default = config.meta.username;
        keyboard.layout = config.meta.keyboardLayout;
        cursor = {
          theme = config.meta.cursor.name;
          size = config.meta.cursor.size;
          path = pkgs.bibata-cursors;
        };
        appearance.hide_logo = true;
        clock = {
          position = "top-center";
          time_format = "{:%H:%M}";
          date_format = "%A, %-d %B %Y";
          time_font_size = 120;
          date_font_size = 34;
        };
      };
    };
  };
}

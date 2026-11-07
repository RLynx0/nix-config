{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.defaultSession = "hyprland-uwsm";
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "lynx" ];
    settings = {
      session.default = "Hyprland (uwsm-managed)";
      user.default = "lynx";
      keyboard.layout = "at";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
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
  services.gnome.gnome-keyring.enable = true;
  services.fprintd.enable = true;
  # greetd delegates to login's PAM stack, including GNOME Keyring and password-only auth.
  security.pam.services.login.fprintAuth = false;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.xserver.xkb = {
    layout = "at";
    variant = "";
  };
}

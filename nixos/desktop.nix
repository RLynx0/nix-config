{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland-uwsm";
  services.gnome.gnome-keyring.enable = true;
  services.fprintd.enable = true;
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

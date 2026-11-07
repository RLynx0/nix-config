{
  flake.modules.nixos.auth = {
    services.gnome.gnome-keyring.enable = true;
    services.fprintd.enable = true;
    # greetd delegates to login's PAM stack, including GNOME Keyring.
    security.pam.services.login.fprintAuth = false;
  };
}

{
  flake.modules.homeManager.hyprland = { config, pkgs, ... }: {
    xdg.configFile."scripts/gammashift.sh".source = ./config/helpers/gammashift.sh;
    home.packages = [ pkgs.wl-gammarelay-rs ];
    systemd.user.services.wl-gammarelay = {
      Unit = {
        Description = "Gamma control for gammashift";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}

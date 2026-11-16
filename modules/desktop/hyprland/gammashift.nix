{ inputs, ... }:
{
  flake.modules.homeManager.hyprland =
    { config, pkgs, ... }:
    let
      gammashift = inputs.gammashift.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      home.packages = [
        gammashift
        pkgs.wl-gammarelay-rs
      ];
      systemd.user.services.wl-gammarelay = {
        Unit = {
          Description = "Gamma control for gammashift";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
        };
        Service = {
          Type = "dbus";
          BusName = "rs.wl-gammarelay";
          ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
          Restart = "on-failure";
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
      systemd.user.services.gammashift = {
        Unit = {
          Description = "Smooth gamma transitions";
          Requires = [ "wl-gammarelay.service" ];
          PartOf = [
            config.wayland.systemd.target
            "wl-gammarelay.service"
          ];
          After = [
            config.wayland.systemd.target
            "wl-gammarelay.service"
          ];
        };
        Service = {
          ExecStart = "${gammashift}/bin/gammashift start";
          RuntimeDirectory = "gammashift";
          RuntimeDirectoryMode = "0700";
          Restart = "on-failure";
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}

{ inputs, ... }:
{
  flake.modules.nixos.amdGpu = { pkgs, ... }: {
    nixpkgs.overlays = [
      (_: prev: {
        # LACT 0.9.1 requires libdisplay-info < 0.4.0.
        lact = prev.lact.override {
          libdisplay-info =
            inputs.nixkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.libdisplay-info;
        };
      })
    ];

    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    services.lact.enable = true;
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}

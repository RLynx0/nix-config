{
  flake.modules.nixos.egpu =
    { pkgs, ... }:
    let
      egpuSleepInhibitor = pkgs.writeShellScript "egpu-sleep-inhibitor" ''
        set -euo pipefail

        egpu_connected() {
          local device
          for device in /sys/bus/pci/devices/*; do
            [[ -r "$device/vendor" ]] || continue
            if [[ "$(<"$device/vendor")" == 0x1002 &&
                  "$(<"$device/device")" == 0x747e &&
                  "$(<"$device/subsystem_vendor")" == 0x1043 &&
                  "$(<"$device/subsystem_device")" == 0x0606 ]]; then
              return 0
            fi
          done
          return 1
        }

        if [[ "$#" -gt 0 && "$1" == "--hold" ]]; then
          while egpu_connected; do
            ${pkgs.coreutils}/bin/sleep 1
          done
          exit 0
        fi

        while true; do
          if egpu_connected; then
            ${pkgs.systemd}/bin/systemd-inhibit \
              --what=sleep:handle-lid-switch \
              --mode=block \
              --who="AMD Radeon eGPU" \
              --why="Prevent suspend while the eGPU is connected" \
              -- "$0" --hold
          else
            ${pkgs.coreutils}/bin/sleep 1
          fi
        done
      '';
    in
    {
      boot.kernelParams = [
        "pci=realloc=on,hpmmioprefsize=1G,resource_alignment=0000:00:07.3"
        "amdgpu.runpm=0"
      ];
      services.hardware.bolt.enable = true;

      systemd.services.egpu-sleep-inhibitor = {
        description = "Block system sleep while the ASUS Radeon eGPU is connected";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${egpuSleepInhibitor}";
          Restart = "on-failure";
          RestartSec = "2s";
        };
      };
    };
}

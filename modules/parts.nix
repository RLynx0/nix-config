{
  systems = [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  perSystem =
    { pkgs, lib, ... }:
    {
      checks = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        desktop =
          pkgs.runCommand "desktop-config-check"
            {
              nativeBuildInputs = with pkgs; [
                bash
                jq
                fish
                hyprland
              ];
            }
            ''
              export HOME="$TMPDIR/home"
              export XDG_RUNTIME_DIR="$TMPDIR/runtime"
              mkdir -p "$HOME" "$XDG_RUNTIME_DIR"
              bash ${../.}/tests/desktop.sh
              fish --no-config --no-execute ${../home/lynx/config/fish/config.fish}
              Hyprland --verify-config -c ${../home/lynx/config/hypr}/hyprland.lua
              touch "$out"
            '';
      };
    };
}

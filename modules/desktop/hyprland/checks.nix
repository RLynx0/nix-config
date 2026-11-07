{
  perSystem =
    { pkgs, lib, ... }:
    {
      checks = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        hyprland =
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
              bash ${./.}/tests/desktop.sh
              Hyprland --verify-config -c ${./config}/hyprland.lua
              touch "$out"
            '';
      };
    };
}

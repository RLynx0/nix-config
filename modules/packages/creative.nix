{
  flake.modules.nixos.creative = { pkgs, config, ... }: {
    environment.systemPackages = with pkgs; [
      # Use PipeWire's JACK implementation, like `pw-jack ardour9`
      (symlinkJoin {
        name = "ardour-pw-jack";
        paths = [ ardour ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          for bin in $out/bin/*; do
            wrapProgram "$bin" --prefix LD_LIBRARY_PATH : ${config.services.pipewire.package.jack}/lib
          done
        '';
      })
      audacity
      bitwig-studio6
      blender
      godot
      inkscape
      krita
      musescore

      # Audio plugins
      calf
      dragonfly-reverb
      helm
      lsp-plugins
      mda_lv2
    ];
  };
}

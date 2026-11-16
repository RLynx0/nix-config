{
  flake.modules.nixos.apps = { pkgs, ... }: {
    nixpkgs.overlays = [
      (_: prev: {
        uhk-agent = prev.uhk-agent.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            docPath=$(${pkgs.jq}/bin/jq -r '.gitInfo | .repo + "/" + .tag' \
              "$out/opt/uhk-agent/packages/firmware/package.json")

            # Node's fs.cp preserves read-only Nix store directory modes.
            wrapProgram "$out/bin/uhk-agent" \
              --run 'docDir="''${XDG_CONFIG_HOME:-$HOME/.config}/uhk-agent/smart-macro-docs/'"$docPath"'"' \
              --run 'if [ -d "$docDir" ]; then ${pkgs.coreutils}/bin/chmod -R u+w "$docDir"; fi' \
              --run '${pkgs.coreutils}/bin/mkdir -p "$docDir/doc-dev"'
          '';
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      baobab
      discord
      kdePackages.gwenview
      kdePackages.kdenlive
      libdvdcss
      libreoffice
      obs-studio
      obsidian
      spotify
      thunderbird
      uhk-agent
      vlc
    ];
  };
}

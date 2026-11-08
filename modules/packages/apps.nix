{
  flake.modules.nixos.apps = { pkgs, ... }: {
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

{
  flake.modules.nixos.cliTools = { pkgs, ... }: {
    services.locate.enable = true;
    environment.systemPackages = with pkgs; [
      bc
      clinfo
      ffmpeg
      gh
      git
      htop
      jq
      just
      lazygit
      ripgrep
      rsync
      strace
      termdown
      tree
      typst
      unzip
      wget
    ];
  };
}

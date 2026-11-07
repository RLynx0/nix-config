{ pkgs, ... }:
{
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
    tree
    typst
    unzip
    wget
  ];
}

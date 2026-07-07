{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bc
    cava
    clinfo
    cliphist
    direnv
    ffmpeg
    gh
    git
    helix
    jq
    just
    kitty
    lazygit
    nix-direnv
    playerctl
    starship
    typst
    unzip
    wget
    wl-clip-persist
    wl-clipboard
    zoxide
  ];
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang-tools
    emmet-language-server
    lua-language-server
    nil
    nixd
    nixfmt
    perlnavigator
    taplo
    tinymist
    tombi
    vscode-langservers-extracted
  ];
}

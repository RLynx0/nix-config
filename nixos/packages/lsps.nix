{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang-tools
    emmet-language-server
    lua-language-server
    nil
    nixd
    nixfmt
    taplo
    tinymist
    tombi
    vscode-langservers-extracted
  ];
}

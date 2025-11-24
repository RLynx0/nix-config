{ pkgs-unstable, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs-unstable.helix;

    extraPackages = with pkgs-unstable; [
      clang-tools
      emmet-language-server
      lldb
      lua-language-server
      nil
      nixd
      nixfmt
      perlnavigator
      rust-analyzer
      taplo
      tinymist
      tombi
      vscode-langservers-extracted
    ];

    settings = import ./settings.nix;
    languages = import ./languages.nix;
    themes.dark-lynx = import ./themes/dark-lynx.nix;
  };
}

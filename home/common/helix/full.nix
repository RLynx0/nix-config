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
      nixfmt-rcf-style
      perlnavigator
      rust-analyzer
      taplo
      tinymist
      tombi
      vscode-langservers-extracted
    ];

    settings = ./config.toml;
    languages = ./languages.toml;
    themes.dark-lynx = ./themes/dark-lynx.toml;
  };
}

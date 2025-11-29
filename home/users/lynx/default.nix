{ pkgs, ... }:

{
  home.username = "lynx";
  home.homeDirectory = "/home/lynx";

  imports = [
    ../../common/hyprland-desktop/full.nix
    ../../common/cli-apps/terminal-toys.nix
    ../../common/git-config.nix
    ../../common/helix/full.nix
  ];

  # User-specific git-config
  programs.git.userName = "RLynx";
  programs.git.userEmail = "luc.signin96@gmail.com";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  home.file.".local/bin" = {
    source = ../../files/.local/bin;
    recursive = true;
    executable = true;
  };
  home.file.".config/scripts" = {
    source = ../../files/.config/scripts;
    recursive = true;
    executable = true;
  };

  home.file.".config/bat" = {
    source = ../../files/.config/bat;
    recursive = true;
  };
  home.file.".config/easyeffects" = {
    source = ../../files/.config/easyeffects;
    recursive = true;
  };
  home.file.".config/fastfetch" = {
    source = ../../files/.config/fastfetch;
    recursive = true;
  };
  home.file.".config/fish" = {
    source = ../../files/.config/fish;
    recursive = true;
  };
  home.file.".config/kitty" = {
    source = ../../files/.config/kitty;
    recursive = true;
  };
  home.file.".config/mako" = {
    source = ../../files/.config/mako;
    recursive = true;
  };
  home.file.".config/npm" = {
    source = ../../files/.config/npm;
    recursive = true;
  };
  home.file.".config/starship.toml" = {
    source = ../../files/.config/starship.toml;
  };
  home.file.".config/waybar" = {
    source = ../../files/.config/waybar;
    recursive = true;
  };
  home.file.".config/waypaper" = {
    source = ../../files/.config/waypaper;
    recursive = true;
  };
  home.file.".config/wofi" = {
    source = ../../files/.config/wofi;
    recursive = true;
  };
  home.file.".config/zellij" = {
    source = ../../files/.config/zellij;
    recursive = true;
  };

  # fcitx5 config
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-anthy
      ];
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    xdg-ninja
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}

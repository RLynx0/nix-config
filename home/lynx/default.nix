{ pkgs, ... }:

{
  home.username = "lynx";
  home.homeDirectory = "/home/lynx";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  home.file.".local/bin" = {
    source = ../files/.local/bin;
    recursive = true;
    executable = true;
  };
  home.file.".config/scripts" = {
    source = ../files/.config/scripts;
    recursive = true;
    executable = true;
  };

  home.file.".config/bat" = {
    source = ../files/.config/bat;
    recursive = true;
  };
  home.file.".config/easyeffects" = {
    source = ../files/.config/easyeffects;
    recursive = true;
  };
  home.file.".config/fish" = {
    source = ../files/.config/fish;
    recursive = true;
  };
  home.file.".config/helix" = {
    source = ../files/.config/helix;
    recursive = true;
  };
  home.file.".config/kitty" = {
    source = ../files/.config/kitty;
    recursive = true;
  };
  home.file.".config/mako" = {
    source = ../files/.config/mako;
    recursive = true;
  };
  home.file.".config/npm" = {
    source = ../files/.config/npm;
    recursive = true;
  };
  home.file.".config/starship.toml" = {
    source = ../files/.config/starship.toml;
  };
  home.file.".config/waybar" = {
    source = ../files/.config/waybar;
    recursive = true;
  };
  home.file.".config/waypaper" = {
    source = ../files/.config/waypaper;
    recursive = true;
  };
  home.file.".config/wlogout" = {
    source = ../files/.config/wlogout;
    recursive = true;
  };
  home.file.".config/wofi" = {
    source = ../files/.config/wofi;
    recursive = true;
  };
  home.file.".config/zellij" = {
    source = ../files/.config/zellij;
    recursive = true;
  };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    kubectl
  ];

  # basic configuration of git
  programs.git = {
    enable = true;
    userName = "RLynx";
    userEmail = "luc.signin96@gmail.com";
    aliases = {
      lg = "lg1";
      lgs = "lg-specific";
      lg-specific = "lg1-specific";

      lg1 = "lg1-specific --all";
      lg2 = "lg2-specific --all";
      lg3 = "lg3-specific --all";
      lg1s = "lg1-specific";
      lg2s = "lg2-specific";
      lg3s = "lg3-specific";

      lg1-specific =
        "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      lg2-specific =
        "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg3-specific =
        "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(comitted: %cD)%C(reset) %C(auto)%d%C(reset)%n''           %C(white)%s%C(reset)%n''           %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";

      staash = "stash --all";
      forget = "!git add . && git stash && git stash clear";
    };
  };

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

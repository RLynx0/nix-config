{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Boot Zen Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "lynx-nixos-vm";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable Display Manager with Hyprland
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Security Related
  services.fail2ban.enable = true;
  security.apparmor.enable = true;
  security.rtkit.enable = true;
  networking.nftables.enable = true;
  networking.firewall.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "at";
    variant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable locate utils
  services.locate.enable = true;

  # Enable bluethooth
  hardware.bluetooth.enable = true;

  # Enable Thunderbolt support
  services.hardware.bolt.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.caskaydia-cove
    source-han-sans-japanese
    source-han-serif-japanese
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "lynx" ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # -- Desktop --
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OYONE_WL = "1";
  };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # -- Packages --
  environment.systemPackages =
    (with pkgs; [
      ardour
      calf
      cava
      fastfetch
      gavin-bc
      gh
      git
      home-manager
      htop
      hypridle
      hyprlock
      kitty
      lazygit
      lf
      libnotify
      mako
      nil
      nixd
      nixfmt-rfc-style
      rustup
      starship
      stow
      tree
      waybar
      wl-clipboard
      wofi
      xfce.thunar
      xfce.thunar-volman
      zellij
      zoxide
    ])
    ++ (with pkgs-unstable; [ helix ]);
}

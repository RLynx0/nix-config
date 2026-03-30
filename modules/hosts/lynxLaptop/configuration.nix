{ self, inputs, ... }:

{
  flake.nixosModules.lynxLaptopConfiguration =
    { config, pkgs, ... }:

    {
      imports = [
        self.nixosModules.lynxLaptopHardware
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "lynx-laptop"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

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
        LC_NUMERIC = "de_AT.UTF-8";
        LC_PAPER = "de_AT.UTF-8";
        LC_TELEPHONE = "de_AT.UTF-8";
        LC_TIME = "de_AT.UTF-8";
      };

      # Enable Display Manager with Hyprland
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.displayManager.defaultSession = "hyprland";

      # -- Desktop --
      xdg.portal.enable = true;
      xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "at";
        variant = "";
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable ThunderBolt support
      services.hardware.bolt.enable = true;

      # Enable sound with pipewire.
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.lynx = {
        isNormalUser = true;
        description = "Lynx";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.fish;
        packages = with pkgs; [
          librewolf
          keepassxc
        ];
      };

      programs.fish.enable = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search, run:
      environment.systemPackages = with pkgs; [
        git
        helix
        kitty
        lazygit
        wget
        jq
        gh
        starship
        zoxide

        # Random Apps
        ardour
        krita
        blender
        inkscape

        # For helix (lsp)
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

        # For hyprland
        waybar
        waypaper
        swww
        wlogout
        hyprlock
        hypridle
        wofi
        libnotify
        thunar
        calc
        mako
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };
}

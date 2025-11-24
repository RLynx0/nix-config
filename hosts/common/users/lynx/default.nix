{ inputs, lib, pkgs, pkgs-unstable, ... }:

{
  programs.fish.enable = true;
  users.users.lynx = {
    isNormalUser = true;
    description = "Lynx";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZPf3ilFPjyJqcPRNjiGJRbqSEjCOe1upI8ai+3hke8L7zfN+DfmPkn2bY//tADEch3/Qny+OvkZiJCBQtrS/bWSsBUI9Zyfd7eYNF0VGvPxNQeN1HiktN/sjK9idM/XQG76TXozveAJGGt/LR3tpZxGwwUPDhAoJAFk819FbmtP9VKpldQx3o7swtqNt5jYyowTzxy0pGYcy1pmxx+GwOgT1LZt/DKtPFBhVzXpTkjdsq9cuSrwqwsy6d+Wc0Sej+ya2y6QrcPw3mXN59o1dS0Bx5xCZEtXMf5CPQ77F7o/H/gDwiFpxoVsMP33WXEnOjBRp7062s1juTHNOd1rkMxDHvlfbVZ9zIOsxqv3UAkFMof4vIw7zGmyUM2sF7ykp64X+/jB6fQSeuKoNTQ/e8tYDH4uG1af80FP7VQF1+kt3XaIybXfd7js8unOlGjFotEnacHuQNbFhdCLz4S29hrNIGGl23p/L0qC+nyLrGoy++wqkQGKm9SMeswq6hhOE= lynx@lynx-laptop"
    ];
  };

  # Home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lynx = import ../../../../home/lynx;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
  };
}

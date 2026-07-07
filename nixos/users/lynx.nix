{ pkgs, ... }:
{
  users.users.lynx = {
    isNormalUser = true;
    description = "Lynx";
    extraGroups = [
      "input"
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
}

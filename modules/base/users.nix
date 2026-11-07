{ config, ... }:
{
  flake.modules.nixos.users = { pkgs, ... }: {
    users.users.${config.meta.username} = {
      isNormalUser = true;
      description = "Lynx";
      extraGroups = [
        "audio"
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
  };
}

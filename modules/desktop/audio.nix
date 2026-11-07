{ config, ... }:
{
  flake.modules.nixos.audio = {
    home-manager.sharedModules = [ config.flake.modules.homeManager.audio ];
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
  flake.modules.homeManager.audio.services.easyeffects.enable = true;
}

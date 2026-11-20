{ config, ... }:
{
  flake.modules.nixos.audio = nixosArgs: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.audio ];
    # Provides `pw-jack` for running JACK clients on PipeWire
    environment.systemPackages = [ nixosArgs.config.services.pipewire.package.jack ];
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  flake.modules.homeManager.audio.services.easyeffects.enable = true;
}

{ config, ... }:
{
  flake.modules.nixos.keyboard.services.xserver.xkb = {
    layout = config.meta.keyboardLayout;
    variant = "";
  };
}

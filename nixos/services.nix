{ pkgs, ... }:
{
  services.locate.enable = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  services.hardware.bolt.enable = true;
}

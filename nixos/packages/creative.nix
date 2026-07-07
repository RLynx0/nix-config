{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ardour
    audacity
    blender
    godot
    inkscape
    krita
    musescore

    # Audio plugins
    calf
    dragonfly-reverb
    helm
    lsp-plugins
    mda_lv2
  ];
}

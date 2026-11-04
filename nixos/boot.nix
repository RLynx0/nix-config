{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "pci=realloc=on,hpmmioprefsize=1G,resource_alignment=0000:00:07.3"
    "amdgpu.runpm=0"
  ];
}

# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.availableKernelModules = [ ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];

    tmpOnTmpfs = true;
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/swapfile"; size = 1024; }];
}

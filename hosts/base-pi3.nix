{ pkgs, ... }: {
  imports = [
    ./base.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    kernelParams = [ "cma=256M" ];
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 3;
        uboot.enable = true;
        firmwareConfig = ''
          gpu_mem=256
        '';
      };
    };
  };
  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];
  # enables wlan0 interface https://github.com/NixOS/nixpkgs/issues/115652#issuecomment-1034075695
  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];
}

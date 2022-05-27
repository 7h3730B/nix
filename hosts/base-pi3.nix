{ pkgs, ... }: {
  imports = [
    ./base.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    kernelParams = ["cma=256M"];
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
}
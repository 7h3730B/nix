{ pkgs, lib, ... }: {
  nixpkgs.crossSystem.system = "aarch64-linux";
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./modules/sshd.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_rpi3;

  # boot.loader.grub.enable = false;
  # boot.loader.raspberryPi = {
  #   enable = true;
  #   version = 3;
  #   uboot.enable = true;
  #   firmwareConfig = ''
  #     enable_uart=1
  #     gpu_mem=256
  #   '';
  # };

  documentation.enable = false;
  sdImage.compressImage = false;

  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  ssh-server = {
    enable = true;
    fail2ban.enable = false;
  };
}

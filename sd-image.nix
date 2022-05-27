{ pkgs, lib, ... }: {
  nixpkgs.crossSystem.system = "aarch64-linux";
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>    
  ];

  boot.kernelPackages = pkgs.linuxPackages_5_4;

  # documentation.enable = false;
  # sdImage.compressImage = false;

  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.sshd.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c80paJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
    ];
  };
}
{ ... }: {
  nixpkgs.crossSystem.system = "armv7l-linux";
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>    
  ];

  users.users.nixos.group = "nixos";
  users.extraUsers.nixos = {
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c80paJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
    ];
  };

  # documentation.enable = false;
  # sdImage.compressImage = false;

  # systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.sshd.enable = true;
}
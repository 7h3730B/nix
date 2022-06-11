{ pkgs
, unstable
, nixos
, home
, username
, config
, ...
}:
let
  hostname = "megumin";
  sshPort = 4444;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
      ./home.nix
    ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;
  };

  # compile for arm
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
    fail2ban.enable = false;
  };

  users.users.nixos = {
    shell = "${pkgs.zsh}/bin/zsh";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
    ];
  };

  documentation.enable = false;
  environment.noXlibs = true;
}

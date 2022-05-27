{ pkgs
, unstable
, nixos
, home
, username
, lib
, ... }:
let
  hostname = "kazuma";
  sshPort = 22;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
    ];

  deploy = {
    enable = true;
    ip = "${hostname}.teo.beer";
    port = sshPort;
  };

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
  };

  nix.maxJobs = lib.mkDefault 4;

  # compile for arm
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader.grub = {
    device = "/dev/sda";
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  networking.interfaces.eth0.useDHCP = true;

  services = {
    resolved = {
      enable = true;
      dnssec = "true";
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };

  security.protectKernelImage = true;

  nix.trustedUsers = [ "root" ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    initialPassword = "${hostname}123";
  };

  documentation.enable = false;
  environment.noXlibs = true;
}
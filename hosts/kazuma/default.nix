{ pkgs
, unstable
, nixos
, home
, username
, lib
, ... }:
let
  # don't set the hostname gets set from dhcps, nixos doesn't allow this hostname and contabo needs it 
  # hostname = "vmd87218.contaboserver.net";
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

  base = {
    DNSOverTLS = true;
    zramSwap = true;
  };

  deploy = {
    enable = true;
    ip = "${hostname}.teo.beer";
    port = sshPort;
  };

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
  };

  # nix.maxJobs = lib.mkDefault 4;

  # compile for arm
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking.useDHCP = false;
  # networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  networking.interfaces.ens18.useDHCP = true;

  # security.protectKernelImage = true;

  nix.trustedUsers = [ "root" ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    initialPassword = "kazuma123";
  };

  # documentation.enable = false;
  # environment.noXlibs = true;
}
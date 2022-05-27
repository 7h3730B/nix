{ pkgs
, unstable
, nixos
, home
, username
, ... }:
let
  hostname = "emilia";
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

  tailscale = {
    enable = true;
    service = true;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  networking.interfaces.enp0s3.useDHCP = true;

  security.protectKernelImage = true;

  nix.trustedUsers = [ "root" ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    initialPassword = "${hostname}123";
  };

  # users.users."${username}" = {
  #   description = "${username}";
  #   isNormalUser = true;
  #   group = "users";
  #   extraGroups = [ ];
  #   createHome = true;
  #   uid = 1000;
  #   home = "/home/${username}";
  #   initialPassword = "${hostname}123";
  #   useDefaultShell = true;
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
  #   ];
  # };

  documentation.enable = false;
  environment.noXlibs = true;
}
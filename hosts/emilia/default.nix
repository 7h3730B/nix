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
  deploy = {
    enable = true;
    ip = "emilia.teo.beer";
    port = sshPort;
  };

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix

      ../../modules/tailscale.nix
      ../../modules/sshd.nix
    ];

  services.openssh = {
    ports = [ sshPort ];
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
    initialPassword = "emilia123";
  };

  users.users."${username}" = {
    description = "${username}";
    isNormalUser = true;
    group = "users";
    extraGroups = [ ];
    createHome = true;
    uid = 1000;
    home = "/home/${username}";
    initialPassword = "123";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHg+H/iAAM1BPI4Ys/c8OpaJMw1RrqIEGmWNY9Gy1X8J teo@albedo"
    ];
  };

  documentation.enable = false;
  environment.noXlibs = true;
}
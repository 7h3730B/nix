{ pkgs
, unstable
, nixos
, home
, username
, ... }:
let
  hostname = "aqua";
in
{
  system.stateVersion = "21.11";
  deploy = {
    enable = true;
    ip = "aqua.teo.beer";
  };

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix

      ../../modules/sshd.nix
    ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };
    };
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  # TODO: get interface name
  networking.interfaces.ens18.useDHCP = true;

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

  nix.trustedUsers = [ "root" username ];

  users.users."${username}" = {
    description = "${username}";
    isNormalUser = true;
    group = "users";
    extraGroups = [ "wheel" ];
    createHome = true;
    uid = 1000;
    home = "/home/${username}";
    initialPassword = "123";
    useDefaultShell = true;
  };

  documentation.enable = false;
  environment.noXlibs = true;

  age.secrets.tailscale-preauthkey.file = ../secrets/tailscale-preauthkey;
}
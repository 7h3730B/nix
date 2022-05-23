{ pkgs
, unstable
, nixos
, home
, username
, ... }:
let
  hostname = "tanya";
  sshPort = 22;
in
{
  system.stateVersion = "21.11";
  deploy = {
    enable = true;
    ip = "tanya.teo.beer";
    port = sshPort;
  };

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix

      ../../modules/sshd.nix
    ];

  services.openssh = {
    ports = [ sshPort ];
    passwordAuthentication = false;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  networking.interfaces.ens3.useDHCP = true;

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
    initialPassword = "tanya123";
  };

  documentation.enable = false;
  environment.noXlibs = true;
}
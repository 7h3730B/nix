{ pkgs
, unstable
, nixos
, home
, username
, ... }:
let
  hostname = "aqua";
  sshPort = 4444;
in
{
  system.stateVersion = "21.11";
  deploy = {
    enable = true;
    ip = "aqua.teo.beer";
    port = sshPort;
  };

  services.openssh.ports = [ sshPort ];

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix

      ../../modules/sshd.nix
    ];

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
  };

  documentation.enable = false;
  environment.noXlibs = true;

  age.secrets.tailscale-preauthkey.file = ../../secrets/tailscale-preauthkey;
}
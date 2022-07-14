{ pkgs
, unstable
, nixos
, home
, username
, config
, ...
}:
let
  hostname = "emilia";
  sshPort = 4444;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base.nix
      ./hardware-configuration.nix
      ./calibre-web.nix
      ./gitea.nix
    ];

  base = {
    enable = true;
    DNSOverTLS = true;
    zramSwap = true;
    networkTweaks = true;
    node-exporter = true;
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

  reverse-proxy = {
    enable = true;
    openFirewall = false;
  };

  calibre-web = {
    enable = true;
    domain = "books.int.teo.beer";
  };

  gitea = {
    enable = true;
    domain = "git.int.teo.beer";
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

  documentation.enable = false;
  environment.noXlibs = false;
}

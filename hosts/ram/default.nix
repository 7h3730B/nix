{ pkgs
, unstable
, nixos
, home
, username
, config
, ...
}:
let
  hostname = "ram";
  sshPort = 22;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base-pi3.nix
      ./hardware-configuration.nix
      ./znc.nix
      ./spotifyd.nix
      ./hostapd.nix
      ./paperless.nix
      ./shiori.nix
    ];


  base = {
    enable = true;
    DNSOverTLS = true;
    zramSwap = false;
    networkTweaks = true;
    node-exporter = true;
  };

  deploy = {
    enable = true;
    ip = "192.168.178.101";
    port = sshPort;
  };

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
  };

  spotifyd.enable = true;

  hostapd.enable = true;

  reverse-proxy = {
    enable = true;
    openFirewall = false;
  };

  paperless = {
    enable = true;
    domain = "docs.int.teo.beer";
  };

  shiori = {
    enable = true;
    domain = "read.int.teo.beer";
  };

  tailscale = {
    enable = true;
    service = true;
    exitNode = "true";
  };

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  networking.interfaces.eth0.useDHCP = true;

  security.protectKernelImage = true;

  nix.trustedUsers = [ "root" ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    initialPassword = "${hostname}123";
  };

  documentation.enable = false;
  # Needs to be enabled, 'cause of some depndencies of paperless'
  environment.noXlibs = false;
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}

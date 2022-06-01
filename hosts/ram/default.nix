{ pkgs
, unstable
, nixos
, home
, username
, config
, ... }:
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
    ];

  base = {
    enable = true;
    DNSOverTLS = true;
    zramSwap = false;
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

  tailscale = {
    enable = true;
    service = true;
    exitNode = "true";
  };

  age.secrets.zncConf = {
    file = ../../secrets/znc.conf;
    owner = "znc";
  };
  services.znc = {
    enable = true;
    mutable = false;
    openFirewall = false;
    configFile = config.age.secrets.zncConf.path;
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
  environment.noXlibs = true;
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}
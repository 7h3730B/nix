{ pkgs
, unstable
, nixos
, home
, username
, ...
}:
let
  hostname = "rem";
  sshPort = 22;
in
{
  system.stateVersion = "21.11";

  imports =
    [
      ../base-pi3.nix
      ./hardware-configuration.nix
      ./monitoring.nix
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
    ip = "192.168.178.69";
    port = sshPort;
  };

  ssh-server = {
    enable = true;
    ports = [ sshPort ];
  };

  monitoring = {
    enable = true;
    grafana.domain = "100.74.11.78";
  };

  tailscale = {
    enable = true;
    service = true;
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

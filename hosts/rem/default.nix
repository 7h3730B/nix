{ pkgs
, unstable
, nixos
, home
, username
, ... }:
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
    ];

  deploy = {
    enable = true;
    # TODO: get IP
    ip = "192.168.178.69";
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
  
  zramSwap.enable = true;

  networking.useDHCP = false;
  networking.hostName = "${hostname}";
  networking.firewall.enable = true;
  # get right interface name
  networking.interfaces.eth0.useDHCP = true;

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
    initialPassword = "${hostname}123";
  };

  documentation.enable = false;
  environment.noXlibs = true;
}
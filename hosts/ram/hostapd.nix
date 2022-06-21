{ config, pkgs, lib, utils, ... }:
with lib;
let
  cfg = config.hostapd;

  escapedInterface = interface: utils.escapeSystemdPath interface;

  hostapdService = interface: {
    description = "hostapd wireless AP on ${interface}";

    path = [ pkgs.hostapd ];
    after = [ "sys-subsystem-net-devices-${escapedInterface interface}.device" ];
    bindsTo = [ "sys-subsystem-net-devices-${escapedInterface interface}.device" ];
    requiredBy = [ "network-link-${escapedInterface interface}.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.hostapd}/bin/hostapd ${config.age.secrets.hostapdConf.path}";
      Restart = "always";
    };
  };
in
{
  options.hostapd = {
    enable = mkEnableOption "wlan interface as ap";

    countryCode = mkOption {
      default = "DE";
      type = with types; nullOr str;
    };

    interface = mkOption {
      default = "wlan0";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.hostapdConf = {
      file = ../../secrets/hostapd.conf;
    #   owner = "hostapd";
    };
    environment.systemPackages = [ pkgs.hostapd ];
    services.udev.packages = optional (cfg.countryCode != null) [ pkgs.crda ];
    systemd.services.hostapd = hostapdService "${cfg.interface}";

    networking.nat.enable = true;
    networking.nat.internalInterfaces = [ "${cfg.interface}" ];

    networking.interfaces."${cfg.interface}".ipv4.addresses = [ { address = "192.168.0.1"; prefixLength = 24; }];

    networking.firewall.interfaces."${cfg.interface}" = {
      allowedUDPPorts = [ 53 67 ];
    };

    services.dnsmasq = {
      enable = true;
      # else sets networking.nameservers to localhost which fucks my resolved config
      resolveLocalQueries = false;
      extraConfig = ''
        # resolved already running
        port=0
        interface=${cfg.interface}
        dhcp-range=interface:wlan0,192.168.0.50,192.168.0.150,255.255.255.0,24h
      '';
    };
  };
}

{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.nginx;
in {
  options.nginx = {
    enable = mkEnableOption "tanya nginx server";

    domain = mkOption {
      type = types.str;
      default = "teo.beer";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      inherit (cfg) enable;
      virtualHosts."${cfg.domain}" = {
        globalRedirect = "arsch.loch.bayern";
      };
      virtualHosts."rfrtfm.${cfg.domain}" = {
        globalRedirect = "readfuckerreadthefuckingmanual.com";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
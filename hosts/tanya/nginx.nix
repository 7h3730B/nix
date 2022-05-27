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

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "${cfg.domain}" = {
          default = true;
          globalRedirect = "arsch.loch.bayern";
        };
        "rfrtfm.${cfg.domain}" = {
          globalRedirect = "readfuckerreadthefuckingmanual.com";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
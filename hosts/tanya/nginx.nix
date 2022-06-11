{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.nginx;
in
{
  options.nginx = {
    enable = mkEnableOption "tanya nginx server";

    domain = mkOption {
      type = types.str;
      default = "teo.beer";
    };
  };

  config = mkIf cfg.enable {
    security.acme = {
      defaults.email = "teo.sb@proton.me";
      acceptTerms = true;
    };
    services.nginx =
      let
        redirect = host: {
          enableACME = true;
          forceSSL = true;
          globalRedirect = host;
        };
      in
      {
        inherit (cfg) enable;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = {
          "${cfg.domain}" = { default = true; } // redirect "arsch.loch.bayern";
          "rfrtfm.${cfg.domain}" = redirect "readfuckerreadthefuckingmanual.com";
          "ip.${cfg.domain}" = {
            enableACME = true;
            forceSSL = true;
            extraConfig = ''
              default_type text/plain;
              return 200 "$remote_addr\n";
            '';
          };
        };
      };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}

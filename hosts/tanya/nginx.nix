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
          extraConfig = "return 301 https://${host};";
        };
        globalRedirect = host: {
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
          "${cfg.domain}" = {
            default = true;
            enableACME = true;
            forceSSL = true;
            locations."/" = redirect "arsch.loch.bayern";
            locations."/nix" = redirect "github.com/7h3730b/nix";
            locations."/nixinfect" = redirect "raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect";
          };
          "rfrtfm.${cfg.domain}" = {
            enableACME = true;
            forceSSL = true;
          } // globalRedirect "readfuckerreadthefuckingmanual.com";
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

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
    reverse-proxy = {
      enable = true;
      openFirewall = true;
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
  };
}

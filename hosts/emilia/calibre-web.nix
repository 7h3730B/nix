{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.calibre-web;
in
{
  options.calibre-web = {
    enable = mkEnableOption "Calibre web books";

    user = mkOption {
      default = "calibre-web";
      type = types.str;
    };
    group = mkOption {
      default = "calibre-web";
      type = types.str;
    };
    listen.port = mkOption {
      default = 8083;
      type = types.port;
    };
    listen.ip = mkOption {
      default = "127.0.0.1";
      type = types.str;
    };
    domain = mkOption {
      default = "127.0.0.1";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.calibre-web = {
      inherit (cfg) enable user group;
      listen = { inherit (cfg.listen) ip port; };
      options = {
        calibreLibrary = "/var/lib/calibre-web/books";
        enableBookConversion = true;
        enableBookUploading = true;
      };
    };

    services.nginx = {
      virtualHosts."0.0.0.0" = {
        default = true;
        extraConfig = "return 301 https://teo.beer;";
      };
      virtualHosts."${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.calibre-web.listen.port}";
          extraConfig = ''
            client_max_body_size 200M;
          '';
        };
      };
    };
  };
}

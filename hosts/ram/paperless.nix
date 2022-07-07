{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.paperless;
in
{
  options.paperless = {
    enable = mkEnableOption "Paperless document managment";

    package = mkOption {
      default = pkgs.paperless-ngx;
      type = types.package;
    };
    user = mkOption {
      default = "paperless";
      type = types.str;
    };
    port = mkOption {
      default = 28981;
      type = types.port;
    };
    address = mkOption {
      default = "127.0.0.1";
      type = types.str;
    };
    domain = mkOption {
      default = "127.0.0.1";
      type = types.str;
    };
    dataDir = mkOption {
      default = "/mnt/ssd/paperless";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.paperlessPassword = {
      file = ../../secrets/paperless.txt;
      owner = config.services.paperless.user;
      group = config.services.paperless.user;
    };

    services.paperless = {
      inherit (cfg) enable package user port address dataDir;
      passwordFile = config.age.secrets.paperlessPassword.path;
      extraConfig = {
        PAPERLESS_URL = "http://${cfg.domain}";
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
      };
    };

    services.nginx = {
      inherit (cfg) enable;

      recommendedOptimisation = true;
      recommendedProxySettings = true;

      virtualHosts."0.0.0.0" = {
        default = true;
        extraConfig = "return 301 https://teo.beer;";
      };
      virtualHosts."${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}

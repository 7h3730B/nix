{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.shiori;
in
{
  options.shiori = {
    enable = mkEnableOption "simple bookmark manager";

    package = mkOption {
      default = pkgs.shiori;
      type = types.package;
    };
    port = mkOption {
      default = 8080;
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
      default = "/mnt/ssd/shiori";
      type = types.str;
    };
    user = mkOption {
      default = "shiori";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      group = "${cfg.user}";
      home = "${cfg.dataDir}";
      isSystemUser = true;
    };
    users.groups."${cfg.user}" = {};

    systemd.services.shiori = {
      environment.SHIORI_DIR = mkForce "${cfg.dataDir}";
      serviceConfig = {
        DynamicUser = mkForce false;
        User = mkForce cfg.user;
        RootDirectory = mkForce "";
        WorkingDirectory = "${cfg.dataDir}";
      };
    };

    services.shiori = {
      inherit (cfg) enable package port address;
    };

    services.nginx = {
      virtualHosts."0.0.0.0" = {
        default = true;
        extraConfig = "return 301 https://teo.beer;";
      };
      virtualHosts."${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.shiori.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}

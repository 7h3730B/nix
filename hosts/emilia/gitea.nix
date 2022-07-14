{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.gitea;
in
{
  options.gitea = {
    enable = mkEnableOption "Gitea git server";

    package = mkOption {
      default = pkgs.gitea;
      type = types.package;
    };
    port = mkOption {
      default = 3000;
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
    user = mkOption {
      default = "gitea";
      type = types.str;
    };
    stateDir = mkOption {
      default = "/var/lib/gitea";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.gitea = {
      inherit (cfg) package user enable stateDir;
      httpPort = cfg.port;
      httpAddress = cfg.address;
      rootUrl = "http://${cfg.domain}";
      disableRegistration = true;
      cookieSecure = false;
      ssh = {
        enable = false;
      };
      settings = {
        DEFAULT.APP_NAME = "Gitea";
        repository = {
          DEFAULT_PRIVATE = "private";
          DEFAULT_BRANCH = "master";
        };
        other.SHOW_FOOTER_VERSION = false;
      };
    };

    services.nginx = {
      virtualHosts."0.0.0.0" = {
        default = true;
        extraConfig = "return 301 https://teo.beer;";
      };
      virtualHosts."${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.gitea.httpPort}";
        };
      };
    };
  };
}

{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.taskserver;
in
{
  options.taskserver = {
    enable = mkEnableOption "taskwarrior server aka taskserver";

    port = mkOption {
      default = 53589;
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
      default = "/mnt/ssd/taskserver";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.taskserver = {
      inherit (cfg) enable dataDir;
      listenPort = cfg.port;
      listenHost = "::";
      fqdn = cfg.domain;
      organisations.main.users = [ "teo" ];
    };
  };
}

{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.monitoring;
in
{
  imports = [
    ./grafana.nix
    ./prometheus.nix
  ];
  options.monitoring = {
    enable = mkEnableOption "Grafana / Prometheus monitoring";

    grafana = {
      port = mkOption {
        type = types.port;
        default = 2342;
      };

      username = mkOption {
        type = types.str;
        default = "admin";
      };

      domain = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };

      passwordFile = mkOption {
        type = types.str;
        default = "/var/lib/grafana/admin-password.txt";
      };
    };

    prometheus = {
      port = mkOption {
        type = types.port;
        default = 9001;
      };
    };
  };

  config = mkIf cfg.enable { };
}

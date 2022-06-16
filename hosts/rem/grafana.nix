{ config, pkgs, lib, ... }:
with lib;
let
  cfg_mon = config.monitoring;
  cfg = cfg_mon.grafana;
in {
  config = mkIf cfg_mon.enable {
    # TODO: use sockets instad of http, add datasource prometheus, add panels, add adminPasswordFile, add Notifiers
    services.grafana = {
      enable = cfg_mon.enable;
      domain = cfg.domain;
      port = cfg.port;
      addr = "127.0.0.1";
      security = {
        adminUser = cfg.username;
        adminPasswordFile = cfg.passwordFile;
      };

      provision = {
        enable = true;
        datasources = [
          {
            isDefault = true;
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            editable = false;
          }
        ];
        dashboards = [
          { name = "Node Stats Full"; folder = "Common"; options.path = ./grafana-dashboard/node-exporter-full.json; }
        ];
      };
    };

    services.nginx = {
      enable = cfg_mon.enable;

      recommendedOptimisation = true;    
      recommendedProxySettings = true;

      virtualHosts."${config.services.grafana.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
          proxyWebsockets = true;
        };
      };
    };

    age.secrets.grafanapw = {
      file = ../../secrets/grafanapw.txt;
      path = config.services.grafana.security.adminPasswordFile;
      owner = "grafana";
    };
  };
}
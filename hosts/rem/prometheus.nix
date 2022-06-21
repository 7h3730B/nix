{ config, pkgs, lib, ... }:
with lib;
let
  cfg_mon = config.monitoring;
  cfg = cfg_mon.prometheus;
in
{
  config = mkIf cfg_mon.enable {
    services.prometheus = {
      enable = cfg_mon.enable;
      port = cfg.port;
      globalConfig.scrape_interval = "15s";
      # exporters.node.port = 9002;
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [{
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "100.127.171.86:${toString config.services.prometheus.exporters.node.port}"
              "100.103.172.7:${toString config.services.prometheus.exporters.node.port}"
              "100.123.177.16:${toString config.services.prometheus.exporters.node.port}"
            ];
          }];
        }
      ];
    };
  };
}

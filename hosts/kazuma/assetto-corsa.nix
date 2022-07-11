{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.assetto-corsa;

in
{
  options.assetto-corsa = {
    enable = mkEnableOption "assetto-corsa dedicated server";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/assetto-corsa";
      description = ''
        Directory to store all data
      '';
    };

    configFile = mkOption {
      type = types.path;
      default = "/var/lib/assetto-corsa/config.yml";
      description = ''
        path to config.yml file
      '';
    };

    serversFile = mkOption {
      type = types.path;
      default = "/var/lib/assetto-corsa/servers.yml";
      description = ''
        path to servers.yml file
      '';
    };

    licenseFile = mkOption {
      type = types.path;
      default = "/var/lib/assetto-corsa/ACSM.License";
      description = ''
        path to ACSM.License file
      '';
    };

    dockerTokenFile = mkOption {
      type = types.path;
      default = "/run/agenix.d/docker_token";
      description = ''
        path to docker token  file
      '';
    };

    user = mkOption {
      type = types.str;
      default = "assetto";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Wether to open ports in the firewall
      '';
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman.enable = true;

      oci-containers.containers = {
        assetto-server-manager = {
          login = {
            username = "7h3730b";
            registry = "https://docker.io";
            passwordFile = "${cfg.dockerTokenFile}";
          };
          user = "${cfg.user}:${cfg.user}";
          image = "7h3730b/ac-server-manager:v1";
          # image = "seejy/assetto-server-manager:latest";

          # bind to localhost to be able to use my normal firewall
          ports = [
            "127.0.0.1:9600-9604:9600-9604"
            "127.0.0.1:9600-9604:9600-9604/udp"
            "127.0.0.1:8081-8085:8081-8085"
            "8772:8772"
          ];

          volumes = [
            "${cfg.dataDir}/data:/home/assetto/server-manager/assetto"
            "${cfg.dataDir}/servers:/home/assetto/server-manager/servers"
            "${cfg.dataDir}/shared_store.json:/home/assetto/server-manager/shared_store.json"
            "${cfg.configFile}:/home/assetto/server-manager/config.yml"
            "${cfg.serversFile}:/home/assetto/server-manager/servers.yml"
            "${cfg.licenseFile}:/home/assetto/server-manager/ACSM.License"
          ];
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPortRanges = [ { from = 9600; to = 9604; } ];
      allowedTCPPortRanges = [ { from = 9600; to = 9604; } { from = 8081; to = 8085; } ];
      allowedTCPPorts = [ 8772 ];
    };
  };
}

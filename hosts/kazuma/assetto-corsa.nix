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
      # oci-containers.backend = "podman";
      # podman.enable = true;
      oci-containers.backend = "docker";
      docker.enable = true;

      oci-containers.containers = {
        assetto-server-manager = {
          # user = "${cfg.user}:${cfg.user}";
          image = "seejy/assetto-server-manager:latest";

          # bind to localhost to be able to use my normal firewall
          ports = [
            "127.0.0.1:9600:9600"
            "127.0.0.1:9600:9600/udp"
            "127.0.0.1:8081:8081"
            "127.0.0.1:8772:8772"
          ];

          volumes = [
            "${cfg.dataDir}/data:/home/assetto/server-manager/assetto"
            "${cfg.configFile}:/home/assetto/server-manager/config.yml"
          ];
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ 9600 ];
      allowedTCPPorts = [ 9600 8081 8772 ];
    };
  };
}

{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.xrdp;
in {
  options.xrdp = {
    enable = mkEnableOption "xrdp service";

    port = mkOption {
      type = types.port;
      default = 3389;
      description = ''
        port xrdp should listen on
      '';
    };
  };

  config = mkIf cfg.enable {
    services.xrdp = {
      inherit (cfg) enable port;
      openFirewall = true;
    };
  };
}
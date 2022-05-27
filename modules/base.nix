{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.base;
in {
  options.base = {
    enable = mkEnableOption "base configs";

    zramSwap = mkOption {
      type = types.bool;
      default = false;
    };

    DNSOverTLS = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge 
  [{
    zramSwap.enable = cfg.zramSwap;
  }
  (mkIf cfg.DNSOverTLS {
    services = {
      resolved = {
        enable = true;
        dnssec = "true";
        fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
        extraConfig = ''
          DNSOverTLS=yes
        '';
      };
    };
  })]);
}
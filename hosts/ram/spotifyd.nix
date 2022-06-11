{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.spotifyd;
in
{
  options.spotifyd = {
    enable = mkEnableOption "tanya nginx server";
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    age.secrets.spotifyPw = {
      file = ../../secrets/spotifypw.txt;
      owner = "spotifyd";
    };

    services.spotifyd = {
      enable = true;
      settings = {
        global = {
          username = "lmozexxk988w2dq0ko2gv2j77";
          password_cmd = "${pkgs.coreutils}/bin/cat ${config.age.secrets.spotifyPw.path}";
          backend = "alsa";
          device = "default:CARD=ALSA";
          mixer = "PCM";
          volume_controller = "alsa";
          device_name = "${config.networking.hostName}-spotifyd";
          bitrate = 320;
          volume_normalisation = true;
          normalisation_pregain = -10;
        };
      };
    };
  };
}

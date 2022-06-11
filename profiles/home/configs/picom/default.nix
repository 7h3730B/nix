{ pkgs
, config
, lib
, ...
}: {
  services.picom = {
    enable = true;
    backend = "xrender";

    shadow = false;
    blur = false;

    fade = true;
    fadeDelta = 3;

    activeOpacity = "0.9";
    inactiveOpacity = "0.8";
  };
}

{ pkgs
, unstable
, nixos
, home
, username
, colorscheme
, palette
, configDir
, ... }: {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nixPath =
      let path = toString ../.;
      in
      [
        "nixos-unstable=${unstable}"
        "nixpkgs=${nixos}"
        "nixpkgs-overlays=${path}/overlays"
        "home-manager=${home}"
      ];
    
    registry = {
      unstable.flake = unstable;
      nixos.flake = nixos;
      home-manager.flake = home;
    };

    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];

    useSandbox = true;

    autoOptimiseStore = true;
    optimise = {
      automatic = true;
      dates = [ "19:00" ];
    };
    
    gc = {
      automatic = true;
      dates = "Sun 13:00";
      options = "--delete-older-than 30d";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    unrar
    unzip
    zip

    curl

    coreutils-full
    file
    git
    vim

    man-db
    man-pages
    stdmanpages
    posix_man_pages
  ];
}

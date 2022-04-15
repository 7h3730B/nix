{ self, pkgs, home, unstable, nixos, ... }: {
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
  time.timeZone = "Europe/Berlin";

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
      noto-fonts
      noto-fonts-emoji
      fira-code
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Serif Nerd Font" ];
      sansSerif = [ "NotoSans Nerd Font" "Noto Sans" ];
      monospace = [ "Fira Code Nerd Font" "Fira Code Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    unrar
    unzip
    zip

    curl
    wget

    coreutils-full
    tldr
    fd
    fzf
    file
    pulsemixer
    jq
    git

    man-db
    man-pages
    stdmanpages
    posix_man_pages
  ];
}

{ pkgs
, unstable
, nixos
, home
, username
, colorscheme
, palette
, configDir
, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      asciinema
      brave
      delta
      exa
      fd
      file
      jq
      ranger
      xclip
      gh
    ];

    programs.git = {
      enable = true;
    } // (import "${configDir}/git");
  };
}

{ pkgs
, unstable
, nixos
, home
, username
, ... }: 
let
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users."nixos" = {
    imports = [
      ../../profiles/home/configs/zsh
      ../../profiles/home/configs/vim
      ../../profiles/home/configs/starship
      ../../profiles/home/configs/tmux
    ];

    home.packages = with pkgs; [
      git
      delta
      exa
      fd
      file
      jq
      ranger
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };
}

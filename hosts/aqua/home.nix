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

  home-manager.users."${username}" = {
    imports = [];

    home.packages = with pkgs; [];

    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}

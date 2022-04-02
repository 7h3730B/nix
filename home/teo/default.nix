{ pkgs, ...}: {
  import = [
    ../i3/default.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.teo = {
    imports = [];

    home.packages = with pkgs; [
      ghidra
    ];
  };
}
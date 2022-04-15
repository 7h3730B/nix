{ pkgs, ...}: {
  # System imports
  imports = [
    ../programs/i3.nix
    ../programs/zsh.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # home imports
  home-manager.users.teo = {
    imports = [
      ../programs/tmux.nix
      ../programs/alacritty.nix
    ];

    home.packages = with pkgs; [
      # ghidra
    ];
  };
}

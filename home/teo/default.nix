{ pkgs, ...}: {
  # System imports
  imports = [
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
      ../programs/i3.nix
      ../programs/zsh.nix
    ];

    home.packages = with pkgs; [
      # ghidra
    ];
  };
}

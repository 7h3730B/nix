{ pkgs, ...}: {
  imports = [];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.teo = {
    imports = [
      ../programs/i3.nix
      ../programs/tmux.nix
      ../programs/zsh.nix
      ../programs/alacritty.nix
    ];

    home.packages = with pkgs; [
      # ghidra
    ];
  };
}

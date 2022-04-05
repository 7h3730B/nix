{ pkgs, ...}: {
  programs = {
    zsh.enable = true;
    fzf.enable = {
      enable = true;
      enableZshIntegration = true;
    }; 
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    }
  };
}
{ pkgs, ...}: {
  home.packages = with pkgs; [ exa lsd vim delta bat ];

  programs = {
    zsh.enable = true;
    fzf = {
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
    };
  };
}
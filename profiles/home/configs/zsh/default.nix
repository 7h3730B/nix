{ pkgs
, ... }: 
let
in {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "nmap"
        "git"
        "git-extras"
        "tmux"
        "vi-mode"
      ];
    };

    initExtra = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin

      _comp_options += (globdots)

      # Use vi keys in completion menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      # Use vi keys in history menu
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      setopt extendedglob
    '';
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };
}
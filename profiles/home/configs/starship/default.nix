{ pkgs
, config
, lib
, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[λ ›](bold green)";
        error_symbol = "[λ x](bold red)";
        vicmd_symbol = "[λ ·](bold green)";
      };

      git_status = {
        format = "([\\($staged$untracked$modified$renamed$deleted\\)]($style) )";
        staged = "[$\{count\}s](fg:blue bold)";
        untracked = "[$\{count\}a](fg:green bold)";
        modified = "[$\{count\}m](fg:yellow bold)";
        renamed = "[$\{count\}r](fg:purple bold)";
        deleted = "[$\{count\}d](fg:red bold)";
        style = "bold purple";
      };
    };
  };
}
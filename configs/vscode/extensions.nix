{ pkgs
, ... }: {
  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
    dracula-theme.theme-dracula
    vscodevim.vim
  ];
}
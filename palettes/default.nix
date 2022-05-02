{ pkgs
, config
, lib
, ... }: 
let
  colorscheme = "tokyonight";
in {
  imports = [
    ("./tokyonight/${colorscheme}")
  ];
}
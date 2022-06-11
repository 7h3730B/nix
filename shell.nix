{ pkgs ? import <nixpkgs> {} , inputs, system }:
let
  inherit (inputs) agenix deploy-rs;
in 
with pkgs;
mkShell {
  name = "flk";
  buildInputs = [
    nixpkgs-fmt

    deploy-rs.defaultPackage."${system}"
    agenix.defaultPackage."${system}"
    # inputs.agenix.packages.agenix
    # inputs.deploy-rs.packages.deploy-rs
  ];
}

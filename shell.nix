{ pkgs ? import <nixpkgs> { }, inputs, system }:
let
  inherit (inputs) agenix deploy-rs;
in
with pkgs;
mkShell {
  name = "nixos-cfg";
  buildInputs = [
    git
    nixpkgs-fmt

    deploy-rs.defaultPackage."${system}"
    agenix.defaultPackage."${system}"
  ];
}

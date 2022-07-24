{ nixpkgs ? import <nixpkgs> {}, pythonPkgs ? nixpkgs.pkgs.python37Packages }:

with pythonPkgs;
buildPythonPackage rec {
  pname = "git-backup";
  version = "0.1";

  src = ./src;

  dontUnpack = true;
  dontBuild = true;
  doCheck = false;

  buildInputs = [  ];

  propagatedBuildInputs = [ PyGithub requests ];
}

{ nixpkgs ? import <nixpkgs> {}, pythonPkgs ? nixpkgs.pkgs.python37Packages }:

with pythonPkgs;
buildPythonPackage rec {
  pname = "git-backup";
  version = "0.1";

  src = ./git-backup.py;

  doCheck = false;

  buildInputs = [  ];

  propagatedBuildInputs = [ PyGithub requests ];
}

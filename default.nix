{ pkgs ? import <nixpkgs> { }
, pureLib ? import ./pure-lib { inherit (pkgs) lib; }
}:

pkgs.callPackage ./lib { inherit pureLib; }

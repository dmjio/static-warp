{ pkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:

let
  haskellPackages = pkgs.haskell.packages."${compiler}";
in

import ./project.nix {
  inherit (pkgs) stdenv;
  inherit haskellPackages;
}

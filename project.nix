{ haskellPackages, stdenv }:

with haskellPackages;

mkDerivation {
  pname = "static-warp";
  version = "1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base
    wai
    wai-app-static
    wai-extra
    warp
    optparse-applicative
    directory
  ];
  testDepends = [cabal-install];
  license = stdenv.lib.licenses.unfree;
}

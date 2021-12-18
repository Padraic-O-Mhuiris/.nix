{ pkgs, lib, steam-run, stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "prysmbeacon";
  version = "2.0.5";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/beacon-chain-v${version}-linux-amd64";
    sha256 = "edba2f6bb6fec8313fffaa0855805f7482f5022c4a51c19c20794371dd0e11b9";
  };

  nativeBuildInputs = [ makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src $out/bin/.prysmbeacon-unwrapped
    makeWrapper ${steam-run}/bin/steam-run $out/bin/prysmbeacon --add-flags $out/bin/.prysmbeacon-unwrapped
  '';

  meta = {
    homepage = "https://github.com/prysmaticlabs/prysm";
    description = "Beacon node implementation for Ethereum proof-of-stake";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
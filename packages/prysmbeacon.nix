{ pkgs, lib, steam-run, stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "prysmbeacon";
  version = "2.1.1";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/beacon-chain-v${version}-linux-amd64";
    sha256 = "4bea44a2298a99dcad3f89e9a45484c047db5694068290e88f93f6aec9969c1b";
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

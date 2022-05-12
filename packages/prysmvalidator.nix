{ pkgs, lib, steam-run, stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "prysmvalidator";
  version = "2.1.1";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/validator-v${version}-linux-amd64";
    sha256 = "14fdd5799395ff54df5fba30be3761ab6e0036ddde0077ab27656d622df8d2f0";
  };

  nativeBuildInputs = [ makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src $out/bin/.prysmvalidator-unwrapped
    makeWrapper ${steam-run}/bin/steam-run $out/bin/prysmvalidator --add-flags $out/bin/.prysmvalidator-unwrapped
  '';

  meta = {
    homepage = "https://github.com/prysmaticlabs/prysm";
    description = "Validator implementation for Ethereum proof-of-stake";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}

{ pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  name = "prysmbeacon";
  version = "4.0.0";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/beacon-chain-v${version}-linux-amd64";
    sha256 =
      "2842cbf43980cec9f51e1c83c21a598c35ccff4d22de2f6f482df010c2bda806 ";
  };

  nativeBuildInputs = [ makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src $out/bin/.prysmbeacon-unwrapped
    makeWrapper ${steam-run}/bin/steam-run $out/bin/prysmbeacon --add-flags $out/bin/.prysmbeacon-unwrapped
  '';

  # meta = {
  #   homepage = "https://github.com/prysmaticlabs/prysm";
  #   description = "Beacon node implementation for Ethereum proof-of-stake";
  #   license = lib.licenses.gpl3;
  #   platforms = [ "x86_64-linux" ];
  #   maintainers = [ ];
  # };
}

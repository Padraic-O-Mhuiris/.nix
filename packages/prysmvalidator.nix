{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "prysmvalidator";
  version = "4.0.0";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/validator-v${version}-linux-amd64";
    sha256 = "4f10c6db1afb5fcd19c56bdf36dc03915f62d05cb652edab4a7ca0ed456644ed";
  };

  nativeBuildInputs = [ makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src $out/bin/.prysmvalidator-unwrapped
    makeWrapper ${steam-run}/bin/steam-run $out/bin/prysmvalidator --add-flags $out/bin/.prysmvalidator-unwrapped
  '';

  # meta = {
  #   homepage = "https://github.com/prysmaticlabs/prysm";
  #   description = "Validator implementation for Ethereum proof-of-stake";
  #   license = lib.licenses.gpl3;
  #   platforms = [ "x86_64-linux" ];
  #   maintainers = [ ];
  # };
}

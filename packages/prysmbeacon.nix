{pkgs}:
with pkgs;
  stdenv.mkDerivation rec {
    name = "prysmbeacon";
    version = "3.1.0";

    src = fetchurl {
      url = "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/beacon-chain-v${version}-linux-amd64";
      sha256 = "f76aed03c207c2e4ade1c1cde47cbc0828bb7fb9b44d5518e6f13a9b39dacc42";
    };

    nativeBuildInputs = [makeWrapper];
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

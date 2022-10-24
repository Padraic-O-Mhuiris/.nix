{pkgs}:
with pkgs;
  stdenv.mkDerivation rec {
    name = "prysmvalidator";
    version = "3.1.0";

    src = fetchurl {
      url = "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/validator-v${version}-linux-amd64";
      sha256 = "5cf7b7edde35fe8b9a5173b8170712d8697fecee564cb244d647109cfe5f082e";
    };

    nativeBuildInputs = [makeWrapper];
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

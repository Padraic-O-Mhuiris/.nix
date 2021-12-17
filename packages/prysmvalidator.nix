{ pkgs, lib, stdenv, fetchurl, my, autoPatchelfHook }:

stdenv.mkDerivation rec {
  name = "prysmvalidator";
  version = "2.0.5";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/validator-v${version}-linux-amd64";
    sha256 = "5d1d6af1a65d5805914d21350f1c1f1a5df505a3176804090b0667d6931c3544";
  };

  buildInputs = with pkgs; [ glibc ];
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src $out/bin/prysmvalidator
  '';
  dontPatchELF = true;

  preFixup = let libPath = lib.makeLibraryPath [ pkgs.glibc ];
  in ''
    rPath="${libPath}:$out/lib"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $rPath \
      $out/bin/prysmvalidator
  '';
  meta = {
    homepage = "https://github.com/prysmaticlabs/prysm";
    description = "Validator implementation for Ethereum proof-of-stake";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}

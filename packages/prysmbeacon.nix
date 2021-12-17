{ pkgs, lib, stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  name = "prysmbeacon";
  version = "2.0.5";

  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/beacon-chain-v${version}-linux-amd64";
    sha256 = "edba2f6bb6fec8313fffaa0855805f7482f5022c4a51c19c20794371dd0e11b9";
  };

  buildInputs = with pkgs; [ glibc ];
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src $out/bin/prysmbeacon
  '';
  dontPatchELF = true;

  preFixup = let libPath = lib.makeLibraryPath [ pkgs.glibc ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/prysmbeacon
  '';

  meta = {
    homepage = "https://github.com/prysmaticlabs/prysm";
    description = "Beacon node implementation for Ethereum proof-of-stake";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}

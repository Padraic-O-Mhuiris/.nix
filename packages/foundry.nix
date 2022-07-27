{ pkgs, lib, steam-run, stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "foundry";
  version = "nightly";
  src = fetchurl {
    url =
      "https://github.com/foundry-rs/foundry/releases/download/${version}/foundry_nightly_linux_amd64.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    install -m755 -D $src/forge $out/bin/forge
    install -m755 -D $src/cast $out/bin/cast
    install -m755 -D $src/anvil $out/bin/anvil

    makeWrapper ${steam-run}/bin/steam-run $out/bin/forge
    makeWrapper ${steam-run}/bin/steam-run $out/bin/cast
    makeWrapper ${steam-run}/bin/steam-run $out/bin/anvil
  '';

  meta = {
    homepage = "https://github.com/foundry-rs/foundry/";
    description = ''
      Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.
    '';
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}

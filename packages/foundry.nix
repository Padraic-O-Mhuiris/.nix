{ pkgs, lib, steam-run, stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "foundry";
  version = "nightly";
  src = fetchurl {
    url =
      "https://github.com/foundry-rs/foundry/releases/download/${version}/foundry_nightly_linux_amd64.tar.gz";
    sha256 = "1ra88drn5a4vq80v3ykjkc60g2g3y4054s619bx95aqk6bhdbfcx";
  };

  nativeBuildInputs = [ makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src

    mv forge $out/bin/.forge
    mv cast $out/bin/.cast
    mv anvil $out/bin/.anvil

    makeWrapper ${steam-run}/bin/steam-run $out/bin/forge --add-flags $out/bin/.forge
    makeWrapper ${steam-run}/bin/steam-run $out/bin/cast --add-flags $out/bin/.cast
    makeWrapper ${steam-run}/bin/steam-run $out/bin/anvil --add-flags $out/bin/.anvil
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

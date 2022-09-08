{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation rec {
  name = "foundry";
  version = "nightly";
  src = pkgs.fetchurl {
    url =
      "https://github.com/foundry-rs/foundry/releases/download/${version}/foundry_nightly_linux_amd64.tar.gz";
    sha256 = "07pnym20mklq1ccbvb2a1yrp827sp0k5xc349ghc5h97j0pffl4z";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src

    mv forge $out/bin/.forge
    mv cast $out/bin/.cast
    mv anvil $out/bin/.anvil

    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/forge --add-flags $out/bin/.forge
    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/cast --add-flags $out/bin/.cast
    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/anvil --add-flags $out/bin/.anvil
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

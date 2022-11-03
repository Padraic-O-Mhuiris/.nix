{ config, lib, pkgs, ... }:
let
  rustupDirLocation = "$HOME/.rustup";
  toolchain = "nightly";
in {
  environment.sessionVariables = {
    RUSTUP_HOME = rustupDirLocation;
    RUSTUP_TOOLCHAIN = toolchain; # setting this will override current toolchain
  };

  env.PATH = [
    "${rustupDirLocation}/toolchains/${toolchain}-x86_64-unknown-linux-gnu/bin"
  ];

  user.packages = with pkgs; [ rustup ];
}

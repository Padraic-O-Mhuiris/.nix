{ config, lib, pkgs, ... }: {
  environment.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    RUSTUP_TOOLCHAIN = "nightly"; # setting this will override current toolchain
  };

  env.PATH = [
    "$RUSTUP_HOME/toolchains/$RUSTUP_TOOLCHAIN-x86_64-unknown-linux-gnu/bin"
  ];

  user.packages = with pkgs; [ rustup ];
}

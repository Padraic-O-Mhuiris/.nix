{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    hyperfine
    rust-analyzer-nightly
  ];
}

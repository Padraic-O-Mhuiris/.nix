{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs;
    [
      # rustup
      # (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
      # rust-analyzer
    ];
}

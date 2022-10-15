{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
    rust-analyzer
  ];
}

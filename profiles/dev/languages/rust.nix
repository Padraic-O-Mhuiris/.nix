{ config, lib, pkgs, ... }:

# Manage rust toolchain independently of nix
{
  user.packages = with pkgs; [ rust-bin.stable.latest.default rust-analyzer ];
}

{ config, lib, pkgs, ... }:

# Manage rust toolchain independently of nix
{
  user.packages = with pkgs; [ rustup ];
}

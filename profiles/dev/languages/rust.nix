{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [ rust-bin.stable.latest.default rust-analyzer ];
}

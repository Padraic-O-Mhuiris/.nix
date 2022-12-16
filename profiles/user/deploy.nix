{ config, lib, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [ deploy-rs ];
}

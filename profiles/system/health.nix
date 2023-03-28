{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ lm_sensors psensor htop sysstat ];
}

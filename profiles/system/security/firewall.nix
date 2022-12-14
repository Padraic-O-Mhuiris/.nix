{ config, lib, pkgs, ... }:

{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];

  # Needed for tailscale
  networking.firewall.checkReversePath = "loose";
}

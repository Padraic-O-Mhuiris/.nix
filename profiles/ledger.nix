{ config, lib, pkgs, ... }: {
  hardware.ledger.enable = true;

  user.packages = with pkgs; [ ledger-live-desktop ];

}

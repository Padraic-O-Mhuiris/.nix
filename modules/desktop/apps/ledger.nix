{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.apps.ledger;
in {
  options.modules.desktop.apps.ledger = { enable = mkBoolOpt false; };

  users.groups.plugdev = { };

  users."${config.user.name}" = { extraGroups = [ "plugdev" ]; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ledger-live-desktop ledger-udev-rules ];
  };
}

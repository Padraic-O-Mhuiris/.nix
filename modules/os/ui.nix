{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.ui = {
    active = mkOpt types.bool false;
    loginMgr = mkOpt (types.nullOr types.str) null;
    dpi = mkOpt types.int 110;
  };
  config = { environment.systemPackages = with pkgs; [ feh ]; };
}

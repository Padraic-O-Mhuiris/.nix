{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.ui = {
    loginMgr = mkOpt (types.nullOr types.str) null;
    dpi = mkOpt types.int 110;
  };
}

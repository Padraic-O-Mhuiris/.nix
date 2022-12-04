{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = config.os.user.name;
  };
}

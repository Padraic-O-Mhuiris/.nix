{ config, lib, pkgs, ... }:

{
  os.ui.loginMgr = "lightdm";

  services.xserver.displayManager.${config.os.ui.loginMgr} = {
    enable = true;
    greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
      iconTheme = {
        package = pkgs.numix-icon-theme-circle;
        name = "Numix-Circle";
      };
    };
  };
}

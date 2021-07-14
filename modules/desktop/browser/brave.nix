{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browser.brave;
in {
  options.modules.desktop.browser.brave = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      [
        brave
        # (makeDesktopItem {
        #   name = "brave-private";
        #   desktopName = "Brave Web Browser";
        #   genericName = "Open a private Brave window";
        #   icon = "brave";
        #   exec = "${brave}/bin/brave --incognito";
        #   categories = "Network";
        # })
      ];
  };
}

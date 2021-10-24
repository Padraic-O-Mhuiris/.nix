{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browser.brave;
in {
  options.modules.desktop.browser.brave = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      brave
      (makeDesktopItem {
        name = "brave-personal";
        desktopName = "Personal Browser";
        genericName = "Opens personal Brave profile";
        icon = "brave";
        exec = ''
          ${brave}/bin/brave --profile-directory "$HOME/.config/BraveSoftware/BraveSoftware/Profile 1"'';
        categories = "Network";
      })
      (makeDesktopItem {
        name = "brave-worl";
        desktopName = "Work Browser";
        genericName = "Opens work Brave profile";
        icon = "brave";
        exec = ''
          ${brave}/bin/brave --profile-directory "$HOME/.config/BraveSoftware/BraveSoftware/Profile 2"'';
        categories = "Network";
      })
    ];
  };
}

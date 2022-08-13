{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.xst;
in {
  options.modules.desktop.term.xst = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = xst-256color ] && export TERM=xterm-256color
    '';

    user.packages = with pkgs; [
      xst
      (makeDesktopItem {
        name = "xst";
        desktopName = "Suckless Terminal";
        genericName = "Default terminal";
        icon = "utilities-terminal";
        exec = "${xst}/bin/xst";
        categories = [ "Development" "System" "Utility" ];
      })
    ];
  };
}

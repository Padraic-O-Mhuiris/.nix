# modules/desktop/term/st.nix
#
# I like (x)st. This appears to be a controversial opinion; don't tell anyone,
# mkay?

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.st;
in {
  options.modules.desktop.term.st = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = xst-256color ] && export TERM=xterm-256color
    '';

    user.packages = with pkgs; [
      xst # st + nice-to-have extensions
      (makeDesktopItem {
        name = "xst";
        desktopName = "Suckless Terminal";
        genericName = "Default terminal";
        icon = "utilities-terminal";
        exec = "${xst}/bin/xst";
        categories = [ "Development" "System" "Utility" ];
      })
    ];

    # user.packages = with pkgs; [
    #   (st.overrideAttrs (oldAttrs: rec {
    #     src = fetchFromGitHub {
    #       owner = "LukeSmithxyz";
    #       repo = "st";
    #       rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b";
    #       sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag";
    #     };
    #     # Make sure you include whatever dependencies the fork needs to build properly!
    #     buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    #   }))
    #   (makeDesktopItem {
    #     name = "st";
    #     desktopName = "Suckless Terminal";
    #     genericName = "Default terminal";
    #     icon = "utilities-terminal";
    #     exec = "${st}/bin/st";
    #     categories = "Development;System;Utility";
    #   })
    # ];
  };
}

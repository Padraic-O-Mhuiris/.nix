{ config, lib, pkgs, ... }:

let
  cfg = config.xsession.windowManager.i3;

  i3Config = rec {
    modifier = "Mod4";

    keybindings = {
      "${modifier}+q" = "kill";
      "${modifier}+Return" = "exec i3-sensible-terminal";
      "${modifier}+d" = "exec ${cfg.config.menu}";

      "${modifier}+Left" = "focus left";
      "${modifier}+Down" = "focus down";
      "${modifier}+Up" = "focus up";
      "${modifier}+Right" = "focus right";

      "${modifier}+Shift+Left" = "move left";
      "${modifier}+Shift+Down" = "move down";
      "${modifier}+Shift+Up" = "move up";
      "${modifier}+Shift+Right" = "move right";

      "${modifier}+h" = "split h";
      "${modifier}+v" = "split v";
      "${modifier}+f" = "fullscreen toggle";

      "${modifier}+s" = "layout stacking";
      "${modifier}+w" = "layout tabbed";
      "${modifier}+e" = "layout toggle split";

      "${modifier}+Shift+space" = "floating toggle";
      "${modifier}+space" = "focus mode_toggle";

      "${modifier}+p" = "focus parent";
      "${modifier}+c" = "focus child";

      "${modifier}+Shift+minus" = "move scratchpad";
      "${modifier}+minus" = "scratchpad show";

      "${modifier}+1" = "workspace number 1";
      "${modifier}+2" = "workspace number 2";
      "${modifier}+3" = "workspace number 3";
      "${modifier}+4" = "workspace number 4";
      "${modifier}+5" = "workspace number 5";
      "${modifier}+6" = "workspace number 6";
      "${modifier}+7" = "workspace number 7";
      "${modifier}+8" = "workspace number 8";
      "${modifier}+9" = "workspace number 9";
      "${modifier}+0" = "workspace number 10";

      "${modifier}+Shift+1" = "move container to workspace number 1";
      "${modifier}+Shift+2" = "move container to workspace number 2";
      "${modifier}+Shift+3" = "move container to workspace number 3";
      "${modifier}+Shift+4" = "move container to workspace number 4";
      "${modifier}+Shift+5" = "move container to workspace number 5";
      "${modifier}+Shift+6" = "move container to workspace number 6";
      "${modifier}+Shift+7" = "move container to workspace number 7";
      "${modifier}+Shift+8" = "move container to workspace number 8";
      "${modifier}+Shift+9" = "move container to workspace number 9";
      "${modifier}+Shift+0" = "move container to workspace number 10";

      "${modifier}+Shift+c" = "reload";
      "${modifier}+Shift+r" = "restart";
      "${modifier}+Shift+e" =
        "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

      "${modifier}+r" = "mode resize";

      "XF86AudioMute" = "exec amixer set Master toggle";
      "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
      "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";

      "${modifier}+Ctrl+3" = "exec emacsclient -c";
    };

    window.border = 0;

    gaps = {
      inner = 15;
      outer = 5;
    };

    startup = [
      {
        command = "exec i3-msg workspace 1";
        always = true;
        notification = false;
      }
      {
        command = "${pkgs.feh}/bin/feh --bg-scale $HOME/.wallpaper";
        always = true;
        notification = false;
      }
    ];
  };
in {
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = i3Config;
  };
}

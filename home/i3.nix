{ config, lib, pkgs, ... }:

let
  color = (import ./theme.nix).color;

  cfg = config.xsession.windowManager.i3;

  i3Modifier = "Mod4";
  i3Keybindings = rec {
    "${i3Modifier}+q" = "kill";
    "${i3Modifier}+Return" = "exec ${pkgs.rxvt_unicode}/bin/urxvt";
    "${i3Modifier}+x" = "exec ${pkgs.rofi}/bin/rofi -modi run -show run";
    "${i3Modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
    "${i3Modifier}+l" = "exec ${pkgs.i3lock}/bin/i3lock -n -i $HOME/.wallpaper";

    "${i3Modifier}+Left" = "focus left";
    "${i3Modifier}+Down" = "focus down";
    "${i3Modifier}+Up" = "focus up";
    "${i3Modifier}+Right" = "focus right";
    "${i3Modifier}+Shift+Left" = "move left";
    "${i3Modifier}+Shift+Down" = "move down";
    "${i3Modifier}+Shift+Up" = "move up";
    "${i3Modifier}+Shift+Right" = "move right";
    "${i3Modifier}+h" = "split h";
    "${i3Modifier}+v" = "split v";
    "${i3Modifier}+f" = "fullscreen toggle";
    "${i3Modifier}+s" = "layout stacking";
    "${i3Modifier}+w" = "layout tabbed";
    "${i3Modifier}+e" = "layout toggle split";
    "${i3Modifier}+Shift+space" = "floating toggle";
    "${i3Modifier}+space" = "focus mode_toggle";
    "${i3Modifier}+p" = "focus parent";
    "${i3Modifier}+c" = "focus child";
    "${i3Modifier}+Shift+minus" = "move scratchpad";
    "${i3Modifier}+minus" = "scratchpad show";
    "${i3Modifier}+1" = "workspace number 1";
    "${i3Modifier}+2" = "workspace number 2";
    "${i3Modifier}+3" = "workspace number 3";
    "${i3Modifier}+4" = "workspace number 4";
    "${i3Modifier}+5" = "workspace number 5";
    "${i3Modifier}+6" = "workspace number 6";
    "${i3Modifier}+7" = "workspace number 7";
    "${i3Modifier}+8" = "workspace number 8";
    "${i3Modifier}+9" = "workspace number 9";
    "${i3Modifier}+0" = "workspace number 10";
    "${i3Modifier}+Shift+1" = "move container to workspace number 1";
    "${i3Modifier}+Shift+2" = "move container to workspace number 2";
    "${i3Modifier}+Shift+3" = "move container to workspace number 3";
    "${i3Modifier}+Shift+4" = "move container to workspace number 4";
    "${i3Modifier}+Shift+5" = "move container to workspace number 5";
    "${i3Modifier}+Shift+6" = "move container to workspace number 6";
    "${i3Modifier}+Shift+7" = "move container to workspace number 7";
    "${i3Modifier}+Shift+8" = "move container to workspace number 8";
    "${i3Modifier}+Shift+9" = "move container to workspace number 9";
    "${i3Modifier}+Shift+0" = "move container to workspace number 10";
    "${i3Modifier}+Shift+c" = "reload";
    "${i3Modifier}+Shift+r" = "restart";
    "${i3Modifier}+Shift+e" =
      "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
    "${i3Modifier}+r" = "mode resize";
    "XF86AudioMute" = "exec amixer set Master toggle";
    "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
    "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
  };

  i3Config = {
    modifier = i3Modifier;
    keybindings = i3Keybindings;

    window.border = 1;
    #gaps = {
    #  inner = 25;
    #  outer = 0;
    #};

    fonts = [ "Iosevka" ];
    colors = {
      focused = {
        border = color 4;
        background = color 4;
        text = color 4;
        indicator = color 4;
        childBorder = color 4;
      };
      focusedInactive = {
        border = color 3;
        background = color 3;
        text = color 3;
        indicator = color 3;
        childBorder = color 3;
      };
      unfocused = {
        border = color 2;
        background = color 2;
        text = color 2;
        indicator = color 2;
        childBorder = color 2;
      };
      urgent = {
        border = color 11;
        background = color 0;
        text = color 0;
        indicator = color 0;
        childBorder = color 11;
      };
      placeholder = {
        border = color 11;
        background = color 0;
        text = color 0;
        indicator = color 0;
        childBorder = color 11;
      };
      background = color 0;

    };

    startup = [
      {
        command = "exec ${pkgs.i3-gaps}/bin/i3-msg workspace 1";
        always = true;
        notification = false;
      }
      {
        command = "exec ${pkgs.feh}/bin/feh --bg-scale $HOME/.wallpaper";
        always = true;
        notification = false;
      }
    ];
  };

in {

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = i3Config;
      extraConfig = ''
        for_window [class="Google-chrome"] border pixel 0
        for_window [class="Spotify"] border pixel 0

      '';
    };
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 1;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -n -i $HOME/.wallpaper";
  };

}

{ config, lib, pkgs, inputs, ... }:

{
  # services.xserver = {
  #   enable = true;
  #   displayManager = {
  #     sddm = {
  #       enable = true;
  #       settings = { };
  #       enableHidpi = true;
  #     };
  #     autoLogin = {
  #       enable = true;
  #       user = config.os.user.name;
  #     };
  #   };
  # };
  os.user.hm = {
    modules = [ inputs.hyprland.homeManagerModules.default ];
    wayland.windowManger.hyperland = {
      enable = true;
      disableAutoreload = false;
      xwayland.enable = true;
      xwayland.hidpi = true;
      nvidiaPatches = true;
      extraConfig = ''
        monitor=,preferred,auto,auto

        env = XCURSOR_SIZE,24

        input {
            kb_layout = us
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =
            follow_mouse = 1
            touchpad {
                natural_scroll = false
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        }

        general {
            gaps_in = 5
            gaps_out = 20
            border_size = 2
            col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
            col.inactive_border = rgba(595959aa)
            layout = dwindle
        }

        decoration {
            rounding = 10
            blur = true
            blur_size = 3
            blur_passes = 1
            blur_new_optimizations = true
            drop_shadow = true
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
        }

        animations {
            enabled = true
            bezier = myBezier, 0.05, 0.9, 0.1, 1.05
            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
        }

        dwindle {
            pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true # you probably want this
        }

        master {
            new_is_master = true
        }

        gestures {
            workspace_swipe = false
        }

        device:epic-mouse-v1 {
            sensitivity = -0.5
        }

        $mainMod = SUPER

        bind = $mainMod RETURN, exec, alacritty,
        bind = $mainMod, Q, killactive,
        bind = $mainMod SHIFT, e, exit,
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, D, exec, rofi -modi drun, run -show drun,
        bind = $mainMod, P, pseudo,
        bind = $mainMod, J, togglesplit, # dwindle

        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow
      '';
    };
  };
}

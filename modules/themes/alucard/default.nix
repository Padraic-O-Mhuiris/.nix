# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.theme;
  fontSize = if config.networking.hostName == "Hydrogen" then "24" else "16";
in {
  config = mkIf (cfg.active == "alucard") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Dracula";
            iconTheme = "Paper";
            cursorTheme = "Paper";
          };
        };

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];

        desktop.browser = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      user.packages = with pkgs; [
        unstable.dracula-theme
        paper-icon-theme # for rofi
      ];
      fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;

        fonts = with pkgs; [
          iosevka
          ubuntu_font_family
          dejavu_fonts
          liberation_ttf
          roboto
          fira-code
          fira-code-symbols
          jetbrains-mono
          siji
          font-awesome-ttf
        ];
        fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [ "Iosevka" ];
            sansSerif = [ "Roboto" ];
          };
        };
      };

      # Compositor
      services.picom = {
        fade = true;
        fadeDelta = 1;
        fadeSteps = [ 1.0e-2 1.2e-2 ];
        shadow = true;
        shadowOffsets = [ (-10) (-10) ];
        shadowOpacity = 0.22;
        # activeOpacity = "1.00";
        # inactiveOpacity = "0.92";
        settings = {
          shadow-radius = 12;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
        };
      };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "#ff79c6"
        password-background-color = "#1E2029"
        window-color = "#181a23"
        border-color = "#181a23"
      '';

      # Other dotfiles
      home.configFile = with config.modules;
        mkMerge [
          {
            # Sourced from sessionCommands in modules/themes/default.nix
            "xtheme/90-theme".text = ''
              !! Colors
              #define blk  #1E2029
              #define bblk #282a36
              #define red  #ffb86c
              #define bred #de935f
              #define grn  #50fa7b
              #define bgrn #0189cc
              #define ylw  #f0c674
              #define bylw #f9a03f
              #define blu  #61bfff
              #define bblu #8be9fd
              #define mag  #bd93f9
              #define bmag #ff79c6
              #define cyn  #8be9fd
              #define bcyn #0189cc
              #define wht  #f8f8f2
              #define bwht #e2e2dc
              #define bg blk
              #define fg wht

              *.foreground:  fg
              *.background:  bg
              *.cursorColor: mag

              *.color0:  blk
              *.color8:  bblk
              *.color1:  red
              *.color9:  bred
              *.color2:  grn
              *.color10: bgrn
              *.color3:  ylw
              *.color11: bylw
              *.color4:  blu
              *.color12: bblu
              *.color5:  mag
              *.color13: bmag
              *.color6:  cyn
              *.color14: bcyn
              *.color7:  wht
              *.color15: bwht

              ! greys
              *.color234: #1E2029
              *.color235: #282a36
              *.color236: #373844
              *.color237: #44475a
              *.color239: #565761
              *.color240: #6272a4
              *.color241: #b6b6b2


              !! general
              st.scratch.font: Iosevka:pixelsize=${fontSize}

              !! xst
              st.font: Iosevka:pixelsize=${fontSize}
              st.borderpx: 10

              !! urxvt
              URxvt*depth:                   32
              URxvt*.background:             blk
              URxvt*.borderless:             1
              URxvt*.buffered:               true
              URxvt*.cursorBlink:            true
              URxvt*.font:                   xft:Iosevka:pixelsize=${fontSize}
              URxvt*.internalBorder:         10
              URxvt*.letterSpace:            0
              URxvt*.lineSpace:              0
              URxvt*.loginShell:             false
              URxvt*.matcher.button:         1
              URxvt*.matcher.rend.0:         Uline Bold fg5
              URxvt*.saveLines:              5000
              URxvt*.scrollBar:              false
              URxvt*.underlineColor:         grey
              URxvt.clipboard.autocopy:      true
              URxvt.iso14755:                false
              URxvt.iso14755_52:             false
              URxvt.perl-ext-common:         default,matcher
            '';
          }
          (mkIf desktop.apps.rofi.enable {
            "rofi/theme" = {
              source = ./config/rofi;
              recursive = true;
            };
          })
          (mkIf (desktop.i3.enable) {
            # "polybar" = {
            #   source = ./config/polybar;
            #   recursive = true;
            # };
            "dunst/dunstrc".source = ./config/dunstrc;
          })

        ];
    })
  ]);
}

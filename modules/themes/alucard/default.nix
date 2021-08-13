# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
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
        mkMerge [{
          # Sourced from sessionCommands in modules/themes/default.nix
          "xtheme/90-theme".source = ./config/Xresources;
        }
        # (mkIf desktop.apps.rofi.enable {
        #   "rofi/theme" = {
        #     source = ./config/rofi;
        #     recursive = true;
        #   };
        # })
        ];
    })
  ]);
}

{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.ui.fonts = {
    monospace = mkOpt types.str "Iosevka Slab Terminal";
    sansSerif = mkOpt types.str "Roboto";
    serif = mkOpt types.str "Roboto";
  };
  config = {
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        corefonts
        (iosevka.override {
          privateBuildPlan = ''
            [buildPlans.iosevka-slab-terminal]
            family = "Iosevka Slab Terminal"
            spacing = "term"
            serifs = "slab"
            no-cv-ss = true
            export-glyph-names = false

            [buildPlans.iosevka-slab-terminal.ligations]
            inherits = "dlig"
          '';
          set = "slab-terminal";
        })
        ubuntu_font_family
        dejavu_fonts
        liberation_ttf
        roboto
        fira-code
        fira-code-symbols
        jetbrains-mono
        siji
        font-awesome
        cascadia-code
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ config.os.ui.fonts.monospace ];
          sansSerif = [ config.os.ui.fonts.sansSerif ];
          serif = [ config.os.ui.fonts.serif ];
        };
      };
    };
  };
}

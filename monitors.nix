{ config, lib, pkgs, ... }:

{
  programs.autorandr = {
    enable = true;

    hooks = {
      preswitch = {
        "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            personal)
              DPI=180
              ;;
            work)
              DPI=100
              ;;
            *)
              echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac
          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';

      };
      postswitch = {
        "change-background" = ''
           case "$AUTORANDR_CURRENT_PROFILE" in
            personal)
              cp -f $HOME/.wallpapers/3840x2160/nord-great-wave $HOME/.wallpaper
              ;;
            work)
              cp -f $HOME/.wallpapers/5120x1440/nord-great-wave $HOME/.wallpaper
              ;;
            *)
              echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac
        '';

        "notify-i3" = "''${pkgs.i3-gaps}/bin/i3-msg restart";
      };
    };

    profiles = {
      work = {
        fingerprint = {
          HDMI-1 =
            "00ffffffffffff004c2d990f55434330271e0103807722782aa2a1ad4f46a7240e5054bfef80714f810081c08180a9c0b3009500d1c01a6800a0f0381f4030203a00a9504100001a000000fd0018781ea03c000a202020202020000000fc00433439524739780a2020202020000000ff00484e4b4e3930333538310a202003b4f00270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009e02033df14c9061601f041312035a5d5e5f2309070783010000e305c0006d030c001000b83c20006001020367d85dc401788003e60605018b7312e20f06565e00a0a0a0295030203500a9504100001a584d00b8a1381440f82c4500a9504100001e0000000000000000000000000000000000000000000000000000000000007f701279000003012833b70088ff139f00";
          eDP-1 =
            "00ffffffffffff0009e5c80700000000011c0104b51f1178026426a85446a8251152590000000101010101010101010101010101010150d000a0f0703e803020350035ae1000001aa6a600a0f0703e803020350035ae1000001a000000fe00424f452048460a202020202020000000fe004e5631343051554d2d4e35330a01f302030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
        };
        config = {
          eDP-1.enable = false;
          HDMI-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "5120x1440";
            gamma = "1.0:0.769:0.556";
            rate = "29.98";
          };
        };
      };
      personal = {
        fingerprint = {
          HDMI-1 =
            "00ffffffffffff004c2d990f55434330271e0103807722782aa2a1ad4f46a7240e5054bfef80714f810081c08180a9c0b3009500d1c01a6800a0f0381f4030203a00a9504100001a000000fd0018781ea03c000a202020202020000000fc00433439524739780a2020202020000000ff00484e4b4e3930333538310a202003b4f00270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009e02033df14c9061601f041312035a5d5e5f2309070783010000e305c0006d030c001000b83c20006001020367d85dc401788003e60605018b7312e20f06565e00a0a0a0295030203500a9504100001a584d00b8a1381440f82c4500a9504100001e0000000000000000000000000000000000000000000000000000000000007f701279000003012833b70088ff139f00";
          eDP-1 =
            "00ffffffffffff0009e5c80700000000011c0104b51f1178026426a85446a8251152590000000101010101010101010101010101010150d000a0f0703e803020350035ae1000001aa6a600a0f0703e803020350035ae1000001a000000fe00424f452048460a202020202020000000fe004e5631343051554d2d4e35330a01f302030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
        };
        config = {
          eDP-1 = {
            position = "0x0";
            mode = "3840x2160";
            crtc = 1;
            rate = "60.00";
            gamma = "1.0:0.769:0.556";

          };
          HDMI-1.enable = false;
        };
      };
    };
  };
}

{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = config.user.name;
    group = config.user.group;
    configDir = "/home/${config.user.name}/.config/syncthing";

    devices = {
      "Oxygen" = {
        name = "Oxygen";
        id = "7TLH75M-N732WQU-YVYWRIY-FGE4JWD-ZJT2R2H-XASE7BI-232JA3R-WY4WVA4";
      };
      "Hydrogen" = {
        name = "Hydrogen";
        id = "XCUKHTC-A2JDZ2R-SBHTJTH-6DV6I7P-5NHONH3-BDGFR34-Q2AIACO-2KZ6LQD";
      };
      # "Lithium" = {
      #   name = "Lithium";
      #   id =
      #     "XE3TRP4-OV33CUZ-R3TXMTW-2D4A6WJ-XGORN64-YKSAMQ6-DD6BDAH-KR24EQ7";
      # };
    };

    folders = {

      "/home/${config.user.name}/sync" = {
        id = "sync";
        devices = [ "Oxygen" "Hydrogen" ];
        watch = true;
        type = "sendreceive";
      };

      # "/home/${config.user.name}/.finance" = {
      #   id = "finances";
      #   devices = [ "Oxygen" "Hydrogen" ];
      #   watch = true;
      #   type = "sendreceive";
      # };

      # "/home/${config.user.name}/.nix" = {
      #   id = "nix";
      #   devices = [ "Oxygen" "Hydrogen" ];
      #   watch = true;
      #   type = "sendreceive";
      # };

      "/home/${config.user.name}/.org" = {
        id = "org";
        devices = [ "Oxygen" "Hydrogen" ];
        watch = true;
        type = "sendreceive";
      };
    };
  };
}

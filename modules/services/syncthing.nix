{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      useInotify = true;
      user = config.user.name;
      group = config.user.group;
      configDir = "/home/${config.user.name}/.config/syncthing";

      declarative = {
        devices = {
          "Oxygen" = {
            name = "Oxygen";
            id =
              "7TLH75M-N732WQU-YVYWRIY-FGE4JWD-ZJT2R2H-XASE7BI-232JA3R-WY4WVA4";
          };
        };

        folders = {
          "/home/${config.user.name}/sync" = {
            id = "sync";
            devices = [ "Oxygen" ];
            watch = true;
            type = "sendrecive";
          };
        };
      };
    };
  };
}

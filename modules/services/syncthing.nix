{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
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
          "Hydrogen" = {
            name = "Hydrogen";
            id =
              "SGEL4MW-HA7XWZU-GU5HZ5L-XBRWDNL-746DNQZ-UNI76NO-HKMJFFB-2LVN2Q2";
          };
        };

        folders = {

          "/home/${config.user.name}/sync" = {
            id = "sync";
            devices = [ "Oxygen" "Hydrogen" ];
            watch = true;
            type = "sendreceive";
          };

          "/home/${config.user.name}/.finances" = {
            id = "finances";
            devices = [ "Oxygen" "Hydrogen" ];
            watch = true;
            type = "sendreceive";
          };

        };
      };
    };
  };
}

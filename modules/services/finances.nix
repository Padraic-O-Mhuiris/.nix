{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.services.finances;
in {
  options.modules.services.finances = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable local server for finances web page";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ fava ];

    systemd.services.finances = {
      description = "finances";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.fava ];

      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.fava}/bin/fava /home/${config.user.name}/.finance/main.beancount";
        ExecStop = "${pkgs.killall} fava";
        Restart = "always";
      };
    };
  };
}

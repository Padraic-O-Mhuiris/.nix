{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      dataDir = "/home/${config.user.name}/shared";
    };
  };
}

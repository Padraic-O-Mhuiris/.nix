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
      dataDir = "/home/${config.user.name}/shared";
      configDir = "/home/${config.user.name}/.config/syncthing";
    };
  };
}

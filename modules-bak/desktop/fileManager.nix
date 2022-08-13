{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.fileManager;
in {
  options.modules.desktop.fileManager = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    #programs.udevil.enable = true;
    user.packages = with pkgs; [ gnome.nautilus udisks udiskie ];
    programs.gnome-disks.enable = true;

    services.xserver.displayManager.sessionCommands = ''
      # launches udiskie on display start and mounts drives
      udiskie -Ns &
    '';

    home.configFile."udiskie/config.yml".text = ''
      ignore_device:
        - device_file: /dev/loop0
          ignore: true
    '';
  };
}

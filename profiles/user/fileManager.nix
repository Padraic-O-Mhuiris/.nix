{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ gnome.nautilus udisks udiskie ];
  services.xserver.displayManager.sessionCommands = ''
    # launches udiskie on display start and mounts drives
    udiskie -Ns &
  '';

  os.user.home.configFile."udiskie/config.yml".text = ''
    ignore_device:
      - device_file: /dev/loop0
        ignore: true
  '';
}

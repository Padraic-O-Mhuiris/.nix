{ config, lib, pkgs, ... }:

{
  services.xserver = {
    layout = "gb";
    libinput.enable = true;
    xkbOptions = "ctrl:swapcaps";
  };
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 233 ];
        events = [ "key" ];
        command = "${pkgs.light}/bin/light -A 3";
      }
      {
        keys = [ 232 ];
        events = [ "key" ];
        command = "${pkgs.light}/bin/light -U 3";
      }
    ];
  };
  user.groups = [ "video" ];
}

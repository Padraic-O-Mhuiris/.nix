{ config, lib, pkgs, ... }:

{
  hardware = {
    pulseaudio.package = pkgs.pulseaudioFull;
    bluetooth = {
      enable = true;
      settings = { General.Enable = "Source,Sink,Media,Socket"; };
    };
  };
  services.blueman.enable = true;
}

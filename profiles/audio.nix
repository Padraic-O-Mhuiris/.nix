{ config, lib, pkgs, ... }:

with lib; {
  hardware = {
    pulseaudio = {
      configFile = let
        inherit (pkgs) runCommand pulseaudio;
        paConfigFile = runCommand "disablePulseaudioEsoundModule" {
          buildInputs = [ pulseaudio ];
        } ''
          mkdir "$out"
          cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
          sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
        '';
      in mkIf config.hardware.pulseaudio.enable "${paConfigFile}/default.pa";
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      settings = { General.Enable = "Source,Sink,Media,Socket"; };
    };
  };
  services.blueman.enable = true;
  user.packages = with pkgs; [ pavucontrol ];
  user.extraGroups = [ "audio" ];
}

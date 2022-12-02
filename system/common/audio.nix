{ config, lib, pkgs, ... }:

{
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      configFile = let
        inherit (pkgs) runCommand pulseaudio;
        paConfigFile = runCommand "disablePulseaudioEsoundModule" {
          buildInputs = [ pulseaudio ];
        } ''
          mkdir "$out"
          cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
          sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
        '';
      in lib.mkIf config.hardware.pulseaudio.enable
      "${paConfigFile}/default.pa";
      package = pkgs.pulseaudioFull;
    };
  };

  environment.systemPackages = with pkgs; [ pavucontrol ];
}

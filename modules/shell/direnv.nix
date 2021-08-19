{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    environment.pathsToLink = [ "/share/nix-direnv" ];

    user.packages = with pkgs; [ direnv nix-direnv ];

    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    home.file."direnvrc".text = ''
      source /run/current-system/sw/share/nix-direnv/direnvrc
    '';
  };
}

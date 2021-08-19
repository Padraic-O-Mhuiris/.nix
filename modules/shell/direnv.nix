{ config, options, lib, pkgs, inputs, system, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.direnv;
  overlay-unstable = final: prev: {
    unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  };
in {
  options.modules.shell.direnv = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [ overlay-unstable ];

    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    environment.pathsToLink = [ "/share/nix-direnv" ];

    user.packages = with pkgs; [
      direnv
      (unstable.nix-direnv.override { enableFlakes = true; })
    ];

    # modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    home.configFile.".direnv/direnvrc".text = ''
      source /run/current-system/sw/share/nix-direnv/direnvrc
    '';
  };
}

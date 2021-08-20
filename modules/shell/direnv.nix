{ config, options, lib, pkgs, inputs, system, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        nix-direnv = super.nix-direnv.override {
          enableFlakes = true;
          nixUnstable = inputs.nixpkgs-unstable;
        };
      })
    ];

    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    environment.pathsToLink = [ "/share/nix-direnv" ];

    user.packages = with pkgs; [ direnv unstable.nix-direnv ];

    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    home.file.".direnvrc".text = ''
      source ${pkgs.unstable.nix-direnv}/share/nix-direnv/direnvrc
    '';
  };
}

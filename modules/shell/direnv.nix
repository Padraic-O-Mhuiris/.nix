{ config, options, lib, pkgs, inputs, system, home-manager, ... }:

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
    # environment.pathsToLink = [ "/share/nix-direnv" ];

    # user.packages = with pkgs; [
    #   direnv
    #   (unstable.nix-direnv.override { enableFlakes = true; })
    # ];

    # modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    # home.configFile."direnv/direnvrc".text = ''
    #   source ${pkgs.unstable.nix-direnv}/share/nix-direnv/direnvrc
    # '';

    home-manager.users.${config.user.name}.programs.direnv = {
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
      # optional for nix flakes support
      programs.direnv.nix-direnv.enableFlakes = true;
    };
  };
}

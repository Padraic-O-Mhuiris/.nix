{ config, options, lib, pkgs, inputs, system, ... }:

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

    user.packages = with pkgs; [
      direnv
      (unstable.nix-direnv.override { enableFlakes = true; })
    ];

    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    home.configFile."direnv/direnvrc".text = ''
      source ${pkgs.unstable.nix-direnv}/share/nix-direnv/direnvrc

      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };
}

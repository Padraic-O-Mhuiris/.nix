{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    direnv
    (nix-direnv.override { enableFlakes = true; })
  ];

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];
}

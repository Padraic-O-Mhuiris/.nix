{
  config,
  lib,
  pkgs,
  ...
}: {
  user.packages = with pkgs; [direnv nix-direnv];
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  environment.pathsToLink = ["/share/nix-direnv"];

  home.file.".direnvrc".text = ''
    source /run/current-system/sw/share/nix-direnv/direnvrc
  '';
}

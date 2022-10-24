# This file searches for a /<HOST>/secrets/secrets.nix file and automatically
# adds the secret to a module config
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with builtins;
with lib; let
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  environment.systemPackages = [inputs.agenix.defaultPackage.x86_64-linux];

  age = {
    secrets =
      if builtins.pathExists secretsFile
      then
        mapAttrs' (n: v:
          nameValuePair (removeSuffix ".age" n) {
            file = "${secretsDir}/${n}";
            owner = v.owner or config.user.name;
            group = v.group or config.user.group;
            mode = v.mode or "0400";
            path = v.path;
            symlink = false;
          }) (import secretsFile)
      else {};
    identityPaths = ["${config.user.directory}/.ssh/id_ed25519"];
  };
}

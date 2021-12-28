{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
let
  inherit (inputs) agenix;
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets = if pathExists secretsFile then
      mapAttrs' (n: v:
        nameValuePair (removeSuffix ".age" n) {
          file = "${secretsDir}/${n}";
          owner = v.owner;
          group = v.group;
          path = v.path;
          symlink = false;
        }) (import secretsFile)
    else
      { };
    sshKeyPaths = [ "${config.user.home}/.ssh/id_ed25519" ];
  };
}

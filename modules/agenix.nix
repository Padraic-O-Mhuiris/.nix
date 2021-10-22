{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
let
  inherit (inputs) agenix;
  secretsDir = ../secrets;
  secretsFile = "${secretsDir}/secrets.nix";

  hostInPublicKeys = host: keyList:
    lists.any (x: x == host)
    (lists.map (s: lists.last (splitString " " s)) keyList);

  buildAgeSecretsForHost = host: secrets:
    mapAttrs (n: v:
      if (hostInPublicKeys config.networking.hostName v.publicKeys) then {
        file = "${secretsDir}/${n}";
      } else
        { }) secrets;

in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets = if pathExists secretsFile then
      buildAgeSecretsForHost config.network.hostName (import secretsFile)
    else
      { };
    #secrets = { ngrokConfig = { file = ../secrets/ngrokConfig.age; }; };

    sshKeyPaths = [ "${config.user.home}/.ssh/id_ed25519" ];
  };
}

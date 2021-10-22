{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
let
  inherit (inputs) agenix;
  secretsDir = ../secrets;
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets = let
      hostInPublicKeys = host: keyList:
        lists.any (x: x == host)
        (lists.map (s: lists.last (splitString " " s)) keyList);

      filterByHost = host: secrets:
        (filterAttrs (n: v: hostInPublicKeys host v.publicKeys) secrets);

      buildAgeSecretsByHost = fn: host: secrets:
        mapAttrs' fn (filterByHost host secrets);

      fn = (n: v:
        nameValuePair (removeSuffix ".age" n) { file = "${secretsDir}/${n}"; });
      fn' = (n: v: nameValuePair (removeSuffix ".age" n) { });

      #hostName = config.networking.hostName;

      buildAgeSecretsForHost = host: secrets:
        mapAttrs (n: v:
          if (hostInPublicKeys config.networking.hostName v.publicKeys) then {
            file = "${secretsDir}/${n}";
          } else
            { }) secrets;

    in if pathExists secretsFile then
      buildAgeSecretsForHost "$HOST" (import secretsFile)
    else
      { };

    #secrets = { ngrokConfig = { file = ../secrets/ngrokConfig.age; }; };

    sshKeyPaths = [ "${config.user.home}/.ssh/id_ed25519" ];
  };
}

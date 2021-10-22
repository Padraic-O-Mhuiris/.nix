{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let
  inherit (inputs) agenix;
  secretsDir = ../secrets;
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  # age = {
  #   secrets = let
  #     hostInPublicKeys = host: keyList:
  #       lists.any (x: x == host)
  #       (lists.map (s: lists.last (splitString " " s)) keyList);

  #     filterByHost = host: secrets:
  #       (filterAttrs (n: v: hostInPublicKeys host v.publicKeys) secrets);

  #     buildAgeSecretsByHost = fn: host: secrets:
  #       mapAttrs' fn (filterByHost host secrets);

  #   in if pathExists secretsFile then
  #     buildAgeSecretsByHost (n: v:
  #       nameValuePair (removeSuffix ".age" n) {
  #         file = "${secretsDir}/${n}";
  #         mode = "0400";
  #       }) (config.networking.hostName) (import secretsFile)
  #   else
  #     { };

  age = {
    secrets = { ngrokConfig = { file = ../secrets/ngrokConfig.age; }; };
    sshKeyPaths = [ "${config.user.home}/.ssh/id_ed25519" ];
  };
}

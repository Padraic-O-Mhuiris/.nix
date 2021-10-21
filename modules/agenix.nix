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

  age = {
    secrets = {
      ngrokConfig = {
        file = ../secrets/ngrokConfig.age;
        mode = "0400";
        owner = "ngrok";
        group = "ngrok";
      };
    };
    sshKeyPaths = [ "${config.user.home}/.ssh/id_ed25519" ];
  };
}

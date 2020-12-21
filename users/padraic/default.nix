{ config, lib, pkgs, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Pádraic Ó Mhuiris";
in {
  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    description = name;
    group = "users";
    hashedPassword = fileContents ../../secrets/padraic;
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

}

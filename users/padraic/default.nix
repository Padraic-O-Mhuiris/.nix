{ config, lib, pkgs, inputs, ... }:

let
  inherit (inputs) home-manager;
  inherit (lib) fileContents mkForce;

  passwordPadraic = mkForce (fileContents ../../secrets/padraic);
in {

  imports = [ home-manager.nixosModules.home-manager ];

  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    group = "users";
    hashedPassword = passwordPadraic;
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

  home-manager.useUserPackages = true;
  home-manager.users.padraic = { imports = [ ../../home ]; };
}

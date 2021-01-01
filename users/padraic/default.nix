{ config, lib, pkgs, inputs, ... }:

let
  inherit (inputs) home-manager;
  inherit (lib) fileContents mkForce;

  passwordPadraic = mkForce (fileContents ../../secrets/padraic);
in {

  imports = [ home-manager.nixosModules.home-manager ];

  home-manager.useUserPackages = true;
  home-manager.users.padraic = {
    imports = [ ./home ];
    home.stateVersion = "20.09";
  };

  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    group = "users";
    hashedPassword = passwordPadraic;
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

}

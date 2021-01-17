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
    extraGroups = [ "wheel" "audio" "networkmanager" "video" "docker" ];
  };

  home-manager.useUserPackages = true;
  home-manager.users.padraic = { imports = [ ../../home ]; };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      SHELL = "zsh";
    };
    homeBinInPath = true;
  };

}

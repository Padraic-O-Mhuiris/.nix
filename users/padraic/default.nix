{ config, lib, pkgs, ... }:

{
  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    group = "users";
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

}

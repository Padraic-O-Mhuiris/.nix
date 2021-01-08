{ config, lib, pkgs, ... }:

{
  home-manager.users.padraic = {
    programs.git = {
      enable = true;
      userName = "Padraic-O-Mhuiris";
      userEmail = "patrick.morris.310@gmail.com";
      signing = {
        key = "0xBD01159F2C44F16B";
        signByDefault = true;
      };
      extraConfig = { http = { postBuffer = "524288000"; }; };
    };

  };

}

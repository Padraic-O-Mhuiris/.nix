{ config, options, lib, pkgs, ... }:

with lib;
let mkOpt = type: default: mkOption { inherit type default; };
in {
  options = {
    user = {
      name = mkOpt types.str "user";
      fullName = mkOpt types.str "user";
      password = mkOpt types.str "";
      email = mkOpt types.str "user@user";
      github = mkOpt types.str "user";
      publicKey = mkOpt types.str "0xUSER";
      packages = mkOpt (types.listOf types.package) [ ];
      groups = mkOpt (types.listOf types.str) [ ];
      ssh = { authorizedKeys = mkOpt (types.listOf types.str) [ ]; };
    };
  };

  config = {
    users.users.${config.user.name} = {
      isNormalUser = true;
      home = "/home/${config.user.name}";
      group = "users";
      description = config.user.fullName;
      extraGroups = [ "wheel" ] ++ config.user.groups;
      uid = 1000;
      hashedPassword = config.user.password;
      packages = config.user.packages;
    };
    users.mutableUsers = false;
  };
}

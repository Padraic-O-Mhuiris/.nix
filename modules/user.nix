{ config, options, lib, pkgs, ... }:

with lib; {
  options = {
    user = {
      name = mkOption { type = types.str; };
      hashedPassword = mkOption { type = types.str; };
    };
    home = {
      file = { };
      configFile = { };
      dataFile = { };
    };
  };

  config = {
    users.users.${config.user.name} = {
      isNormalUser = true;
      home = "/home/${config.user.name}";
      group = "users";
      description = "";
      extraGroups = [ "wheel" ];
      uid = 1000;
      hashedPassword = "${config.user.hashedPassword}";
    };
    home-manager = {
      useUserPackages = true;
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          enableNixpkgsReleaseCheck = false;
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.mutableUsers = false;
    nix = {
      trustedUsers = [ "${config.user.name}" ];
      allowedUsers = [ "${config.user.name}" ];
    };
  };
}

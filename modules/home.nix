{ config, lib, pkgs, ... }:

with lib;
let mkOpt = type: default: mkOption { inherit type default; };
in {
  options = {
    home = {
      file = mkOpt types.attrs { };
      configFile = mkOpt types.attrs { };
      dataFile = mkOpt types.attrs { };
    };
  };

  config = {
    home-manager = {
      useUserPackages = true;
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          enableNixpkgsReleaseCheck = false;
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          enable = true;
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };
  };
}

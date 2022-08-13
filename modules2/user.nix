{ config, lib, pkgs, ... }:

with lib;
let cfg = config.user;
in {
  options = {
    user = {
      name = mkOption { types = type.str; };
      hashedPassword = mkOption { types = type.str; };
    };

    home = {
      file = { }; # $HOME
      configFile = { }; # $XDG_CONFIG_HOME
      dataFile = { }; # $XDG_DATA_HOME"
    };
  };

  config = {
    user = {
      "${cfg.name}" = {
        isNormalUser = true;
        home = "/home/${cfg.name}";
        group = "users";
        extraGroups = [ "wheel" ];
        uid = 1000;
        hashedPassword = "${cfg.hashedPassword}";
        #"$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
      };
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

    users.users.${config.user.name} = mkAliasDefinitions options.user;
    users.mutableUsers = false;
    nix = {
      trustedUsers = [ "${cfg.name}" ];
      allowedUsers = [ "${cfg.name}" ];
    };
  };
}

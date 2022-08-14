{ config, options, lib, pkgs, ... }:

with lib;

let mkOpt = type: default: mkOption { inherit type default; };
in {
  options = {
    user = mkOpt types.attrs { };
    home = {
      file = mkOpt types.attrs { };
      configFile = mkOpt types.attrs { };
      dataFile = mkOpt types.attrs { };
    };

    # dotfiles = let t = either str path;
    # in {
    #   dir = mkOpt t
    #     (findFirst pathExists (toString ../.) [ "${config.user.home}/.nix" ]);
    #   binDir = mkOpt t "${config.dotfiles.dir}/bin";
    #   configDir = mkOpt t "${config.dotfiles.dir}/config";
    #   modulesDir = mkOpt t "${config.dotfiles.dir}/modules";
    #   themesDir = mkOpt t "${config.dotfiles.modulesDir}/themes";
    # };
  };

  config = {
    users.users.${config.user.name} = {
      isNormalUser = true;
      home = "/home/${config.user.name}";
      group = "users";
      description = "${config.user.fullName}";
      extraGroups = [ "wheel" ];
      uid = 1000;
      hashedPassword = "${config.user.password}";
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
          enable = true;
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.mutableUsers = false;
  };
}

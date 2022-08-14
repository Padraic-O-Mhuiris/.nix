{ config, options, lib, xlib, pkgs, ... }:

with lib; {
  options = {
    user = xlib.mkOpt types.attrs { };
    home = {
      file = { };
      configFile = { };
      dataFile = { };
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
          enable = true;
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
      };
    };

    users.mutableUsers = false;
  };
}

{ config, lib, pkgs, ... }:

with lib;

let mkOpt = type: default: mkOption { inherit type default; };
in {

  imports = [ ./neovim.nix ./emacs.nix ];

  options.home = {
    file = mkOpt types.attrs { };
    configFile = mkOpt types.attrs { };
    dataFile = mkOpt types.attrs { };
  };

  config = mkMerge [
    {

      users.users.padraic = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "libvirt" ];
        passwordFile = config.age.secrets.user.padraic.password.path;
      };

      home-manager.users.padraic = {
        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = config.system.stateVersion;
        xdg.enable = true;
      };

      #     file = mkAliasDefinitions options.home.file;
      #     enableNixpkgsReleaseCheck = false;
      #     stateVersion = config.system.stateVersion;
      #   };
      #   xdg.enable = true;
      #   xdg.configFile = mkAliasDefinitions options.home.configFile;
      #   xdg.dataFile = mkAliasDefinitions options.home.dataFile;
      # };
    }
    (lib.host.mkHomeFile "padraic" "xxx" "helloworld")
  ];
}

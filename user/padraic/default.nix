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

  config = {

    users.users.padraic = {
      isNormalUser = true;
      createHome = true;
      shell = pkgs.zsh;
      group = "users";
      extraGroups = [ "wheel" "docker" "libvirt" ];
      passwordFile = config.age.secrets."user.padraic.password".path;
    };

    home-manager.users.padraic = {
      home = {
        file = mkAliasDefinitions options.home.file;
        enableNixpkgsReleaseCheck = false;
        stateVersion = config.system.stateVersion;
      };
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.home.configFile;
      xdg.dataFile = mkAliasDefinitions options.home.dataFile;
    };
  };
}

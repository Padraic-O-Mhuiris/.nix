{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.user = {
    name = mkOpt types.str "nixos";
    packages = mkOpt (types.listOf types.package) [ ];
    shell = mkOpt (types.enum [ "bash" "zsh" ]) "zsh";
    hashedPassword = mkOpt types.str "";
    home = {
      file = mkOpt types.attrs { };
      configFile = mkOpt types.attrs { };
      dataFile = mkOpt types.attrs { };
    };
    # default = {
    #   editor = mkOpt
    # }
  };

  config = {
    users.mutableUsers = false;
    users.defaultUserShell = pkgs.bash;
    users.enforceIdUniqueness = true;
    users.users.root.hashedPassword = null;

    users.users.${config.os.user.name} = {
      isNormalUser = true;
      home = "/home/${config.os.user.name}";
      shell = if config.os.user.shell == "zsh" then pkgs.zsh else pkgs.bash;
      #group = config.user.group;
      #description = config.user.fullName;
      extraGroups = [ "wheel" ]; # ++ config.user.groups;
      uid = 1000;
      #passwordFile = config.user.passwordFile;
      hashedPassword = config.os.user.hashedPassword;
      packages = config.os.user.packages;
      #openssh.authorizedKeys.keys = config.user.ssh.authorizedKeys;
    };

    home-manager = {
      users.${config.os.user.name} = {
        home = {
          file = config.os.user.home.file;
          enableNixpkgsReleaseCheck = false;
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          enable = true;
          configFile = config.os.user.home.configFile;
          dataFile = config.os.user.home.dataFile;
        };
      };
    };

    environment.sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [ "${XDG_BIN_HOME}" ];
    };
  };
}

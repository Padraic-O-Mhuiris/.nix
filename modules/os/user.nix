{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.user = {
    name = mkOpt types.str "nixos";
    passwordFile = mkOpt (types.nullOr types.str) null;
    email = mkOpt types.str "nixos@nixos";
    github = mkOpt types.str "nixos";
    groups = mkOpt (types.listOf types.str) [ ];
    keys = {
      ssh = mkOpt types.str "";
      gpg = mkOpt types.str "";
    };
    packages = mkOpt (types.listOf types.package) [ ];
    shell = mkOpt (types.enum [ "bash" "zsh" ]) "zsh";
    editor = mkOpt (types.enum [ "vim" "emacs" ]) "vim";
    browser = mkOpt (types.enum [ "brave" "firefox" ]) "brave";
    terminal = mkOpt (types.enum [ "alacritty" ]) "alacritty";
    home = {
      file = mkOpt types.attrs { };
      configFile = mkOpt types.attrs { };
      dataFile = mkOpt types.attrs { };
    };
    hm = mkOpt types.attrs { };
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
      extraGroups = [ "wheel" ] ++ config.os.user.groups;
      uid = 1000;
      passwordFile = config.os.user.passwordFile;
      packages = config.os.user.packages;
      openssh.authorizedKeys.keys = [ config.os.user.keys.ssh ];
    };

    home-manager = {
      users.${config.os.user.name} = config.os.user.hm // {
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
      EDITOR = if !config.os.ui.active then "vim" else config.os.user.editor;
      BROWSER = config.os.user.browser;
      TERMINAL = config.os.user.terminal;
    };
  };
}

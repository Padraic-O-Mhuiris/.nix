{ config, lib, pkgs, ... }:

{
  users.mutableUsers = false;
  users.enforceIdUniqueness = true;
  users.users.root.hashedPassword = null;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };
}

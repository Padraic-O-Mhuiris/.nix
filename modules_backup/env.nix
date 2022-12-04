{ config, lib, pkgs, ... }:
with lib; {
  options = with types; {
    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then
          concatMapStringsSep ":" (x: toString x) v
        else
          (toString v));
      default = { PATH = [ "$PATH" ]; };
    };
  };

  config = {
    environment.sessionVariables.PATH = config.env.PATH;
    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'')
        (filterAttrs (n: v: n != "PATH") config.env));
  };
}

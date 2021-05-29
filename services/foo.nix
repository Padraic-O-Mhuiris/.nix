{ config, lib, pkgs, ... }:

with lib;  # use the functions from lib, such as mkIf

let
  # the values of the options set for the service by the user of the service
  foocfg = config.services.foo;
in {
  ##### interface. here we define the options that users of our service can specify
  options = {
    # the options for our service will be located under services.foo
    services.foo = { 
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable foo.
        '';
      };

      bar = mkOption {
        type = types.str;
        default = "qux";
        description = ''
          The bar option for foo.
        '';
      };
    };
  };

  ##### implementation
  config = mkIf foocfg.enable { # only apply the following settings if enabled
    # here all options that can be specified in configuration.nix may be used
    # configure systemd services
    # add system users
    # write config files, just as an example here:
    environment.etc."foo-bar" = {
      text = builtins.readFile foocfg.bar; # we can use values of options for this service here
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ngrok;
  stateDir = "/var/lib/ngrok";
  user = "ngrok";
in {
  ##### interface. here we define the options that users of our service can specify
  options = {
    # the options for our service will be located under services.foo
    services.ngrok = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ngrok service";
      };
      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        descrption = "Path to config.yml";
      };
    };
  };

  config = mkIf ngrok.enable {

  };
}

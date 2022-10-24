{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    xserver = {
      displayManager = {
        defaultSession = "none+i3";
        lightdm.greeters.mini = {
          user = config.user.name;
          extraConfig = ''
            text-color = "#ff79c6"
            password-background-color = "#1E2029"
            window-color = "#181a23"
            border-color = "#181a23"
          '';
        };
        autoLogin = {
          enable = true;
          user = config.user.name;
        };
      };
    };
  };
}

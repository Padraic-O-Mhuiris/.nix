{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    brave
    (makeDesktopItem {
      name = "brave-personal";
      desktopName = "Personal Browser";
      genericName = "Opens personal Brave profile";
      icon = "brave";
      exec = ''${brave}/bin/brave --profile-directory="Default"'';
      categories = [ "Network" ];
    })
    (makeDesktopItem {
      name = "brave-work";
      desktopName = "Work Browser";
      genericName = "Opens work Brave profile";
      icon = "brave";
      exec = ''${brave}/bin/brave --profile-directory="Profile 1"'';
      categories = [ "Network" ];
    })
  ];
}

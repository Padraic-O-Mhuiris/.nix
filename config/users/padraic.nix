{ config, lib, pkgs, ... }:

{
  users.mutableUsers = false;
  users.trustedUsers = "padraic";
  users.allowedUsers = "padraic";
  users.padraic = {
    isNormalUser = true;
    home = "/home/padraic";
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "plugdev" ];
    uid = 1000;
    hashedPassword =
      "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
  };
}

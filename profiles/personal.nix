{ config, lib, pkgs, ... }:

{
  imports = [ ./base.nix ./dev ./networking.nix ];

  user = {
    name = "padraic";
    hashedPassword =
      "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
  };
}

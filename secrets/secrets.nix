let
  Oxygen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWMxDpxfrlXhAyln0+MKZs7q3i1VimlHhGgUxVVaeYY Oxygen";
  Hydrogen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHx6hOIV9jksyymGefvsRoAwGfAPIur92VFFGUUDwj8 Hydrogen";
in { "ngrokConfig.age" = { publicKeys = [ Oxygen ]; }; }

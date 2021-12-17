let
  padraic =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com";
  Oxygen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWMxDpxfrlXhAyln0+MKZs7q3i1VimlHhGgUxVVaeYY Oxygen";
  Hydrogen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHx6hOIV9jksyymGefvsRoAwGfAPIur92VFFGUUDwj8 Hydrogen";
in {

  "ngrokConfig.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "root";
  };
  "sshConfig.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "padraic";
  };
  "validatorPassword.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "prysmvalidator";
    group = "prysmvalidator";
  };
}

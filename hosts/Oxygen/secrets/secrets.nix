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
    owner = "ngrok";
    group = "ngrok";
    path = "/var/lib/ngrok/config.yml";
  };
  "sshConfig.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "padraic";
    group = "user";
    path = "/home/padraic/.ssh";
  };
  "validatorPassword.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "prysmvalidator";
    group = "prysmvalidator";
    path = "/var/lib/prysm/validator/validatorPassword";
  };
}

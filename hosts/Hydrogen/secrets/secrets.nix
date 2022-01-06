let
  padraic =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com";
  Hydrogen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHx6hOIV9jksyymGefvsRoAwGfAPIur92VFFGUUDwj8 Hydrogen";
in {
  "sshConfig.age" = {
    publicKeys = [ padraic Hydrogen ];
    path = "/home/padraic/.ssh";
  };
}

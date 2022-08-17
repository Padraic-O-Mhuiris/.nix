let
  padraic =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com";
  Hydrogen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTaQbDRpxQiC9vjCC11Uaoh1/UCzzWJTB4yfVMvo85T Hydrogen";
in {
  "ssh_config.age" = {
    publicKeys = [ padraic Hydrogen ];
    symlink = false;
    path = "/home/padraic/.ssh/ssh_config";
  };
}

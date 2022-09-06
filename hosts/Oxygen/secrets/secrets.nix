let
  padraic =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com";
  Oxygen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWMxDpxfrlXhAyln0+MKZs7q3i1VimlHhGgUxVVaeYY Oxygen";
in {
  "ngrokConfig.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "ngrok";
    group = "ngrok";
    path = "/var/lib/ngrok/config.yml";
  };
  "sshConfig.age" = {
    publicKeys = [ padraic Oxygen ];
    path = "/home/padraic/.ssh";
  };
  "validatorPassword.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "prysmvalidator";
    group = "prysmvalidator";
    path = "/var/lib/prysm/validator/validatorPassword";
  };
  "jwt.age" = {
    publicKeys = [ padraic Oxygen ];
    owner = "ethereum";
    group = "ethereum";
    path = "/var/lib/ethereum/jwt.hex";
  };
}

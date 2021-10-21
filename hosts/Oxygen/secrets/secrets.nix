let
  key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWMxDpxfrlXhAyln0+MKZs7q3i1VimlHhGgUxVVaeYY Oxygen";
in {

  "ngrokConfig.age" = {
    publicKeys = [ key ];
    owner = "ngrok";
    group = "ngrok";
  };
}

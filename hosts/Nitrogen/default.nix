

{ modulesPath, pkgs, config, ... }: {

  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;

  services.nginx.enable = true;

  user = {
    name = "padraic";
    fullName = "Pádraic Ó Mhuiris";
    email = "patrick.morris.310@gmail.com";
    github = "Padraic-O-Mhuiris";
    publicKey = "9A51DBF629888EE75982008D9DCE7055406806F8";
    ssh.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com"
    ];
  };

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    hosts = { "127.0.0.1" = [ config.networking.hostName ]; };
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    hostKeys = [{
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
      rounds = 100;
      comment = "${config.networking.hostName}";
    }];
  };

  user.packages = with pkgs; [ git vim ];
}

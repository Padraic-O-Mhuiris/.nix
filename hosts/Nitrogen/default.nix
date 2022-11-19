

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

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [ "${config.user.name}" ];
      allowed-users = [ "${config.user.name}" ];
    };
  };

}

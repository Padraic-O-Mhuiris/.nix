{ modulesPath, pkgs, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";
  users.users.padraic = {
    home = "/home/padraic";
    createHome = true;
    group = "users";
    extraGroups = [ "wheel" ];
    hashedPassword =
      "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7"
    ];
  };

  nix = {
    settings.trusted-users = [ "padraic" ];
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  environment.systemPackages = with pkgs; [ vim git ];

  services.openssh.enable = true;
  system.stateVersion = "22.05";
}

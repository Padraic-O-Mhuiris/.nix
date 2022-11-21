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
    package = pkgs.nix;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [ "padraic" ];
      allowed-users = [ "padraic" ];
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  environment.systemPackages = with pkgs; [ vim git htop ];

  services.openssh.enable = true;
  system.stateVersion = "22.05";
}

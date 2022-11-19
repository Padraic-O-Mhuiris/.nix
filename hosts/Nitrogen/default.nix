

{ modulesPath, pkgs, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  ec2.hvm = true;

  services.nginx.enable = true;
  users.users.admin.extraGroups = [ "docker" ];

  user.packages = with pkgs; [ git ];
}

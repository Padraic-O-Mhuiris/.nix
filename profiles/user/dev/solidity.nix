{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ solc foundry-bin ];
}

{ config, lib, pkgs, agenix, ... }:

{
  user.packages = [ agenix.defaultPackage.x86_64-linux ];
}

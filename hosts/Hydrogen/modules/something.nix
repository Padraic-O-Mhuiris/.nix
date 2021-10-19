{ config, lib, pkgs, ... }:

{
  home.file."test".text = builtins.readFile config.age.secrets.something.path;
}

{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  keys = getHostKeys ../hosts;
  Hydrogen = keys.Hydrogen;
  Oxygen = keys.Oxygen;
in { "secret1.age".publicKeys = [ Oxygen Hydrogen ]; }

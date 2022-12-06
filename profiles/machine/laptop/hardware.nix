{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.hardware.nixosModules.dell-xps-15-9500 ];
}

{ config, lib, pkgs, inputs, ... }:

let sops = inputs.sops-nix;
in {
  imports = [ <sops/modules/sops> ];

}

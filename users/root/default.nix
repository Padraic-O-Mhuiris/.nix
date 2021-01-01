{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) fileContents mkForce;

  passwordRoot = lib.mkForce (fileContents ../../secrets/root);
in {
  users.users.root = {
    initialHashedPassword = passwordRoot;
    hashedPassword = passwordRoot;
  };
}

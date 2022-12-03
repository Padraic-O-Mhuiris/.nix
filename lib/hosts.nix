{ config, lib, pkgs, ... }:

with lib; {
  inherit config;
  users = (c:
    filter (x: !(isNull x)) (mapAttrsToList
      (n: v: if ((hasAttr "isNormalUser" v) && v.isNormalUser) then n else null)
      c)) config.users.users;

  # userLib = (user: {
  # })

  mkHomeFile = (user: file: content: {
    home-manager.users.padraic.home.file.${file}.text = "${content}";
  });
}

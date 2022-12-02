{ config, lib, pkgs, inputs, ... }:

{
  environment.systemPackages = [ inputs.agenix.defaultPackage.x86_64-linux ];

  age.secrets."user.padraic.password".file =
    ../secrets/user.padraic.password.age;
}

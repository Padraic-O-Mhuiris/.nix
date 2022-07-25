{ inputs, }:

let inherit (inputs) base16;
in { imports = [ base16.nixosModules ]; }

let key = (builtins.readFile ../key.pub);
in { "ngrok-config.age".publicKeys = [ key ]; }

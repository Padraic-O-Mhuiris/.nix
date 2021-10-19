let key = (builtins.readFile ../key.pub);
in { "ngrok-authtoken".publicKeys = [ key ]; }

let key = (builtins.readFile ../key.pub);
in { "something.age".publicKeys = [ key ]; }

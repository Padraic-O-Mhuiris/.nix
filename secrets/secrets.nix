let
  Hydrogen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6RXJPp92XKKfkIUpnnhX14FgqeFvcO/6JvZMTXkum7 Hydrogen - padraic-o-mhuiris@protonmail.com";
  Oxygen =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHXnABspqcYysmEtN8zKAjrUyxKy5RXm740h3csJWqy Oxygen - padraic-o-mhuiris@protonmail.com";
in { "secret1.age".publicKeys = [ Oxygen ]; }

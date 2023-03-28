(self: super:
  with builtins;
  let lib = self;
  in with lib; {
    os = import ./options.nix { inherit lib; };

    mkHosts = path: args:
      (listToAttrs (map (hostFile:
        nameValuePair (removeSuffix ".nix" hostFile) {
          modules =
            [ (path + "/${(removeSuffix ".nix" hostFile)}") ../modules/os ];
          specialArgs = ({
            inherit (args) inputs;
            lib = lib // { inherit (self) os; };
          });
        }) (attrNames (readDir path))));

  })

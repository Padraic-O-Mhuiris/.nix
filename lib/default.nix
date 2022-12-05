(self: super:
  with builtins;
  let lib = self;
  in with lib; {
    os = import ./options.nix { inherit lib; };

    mkHosts = path:
      (listToAttrs (map (hostFile:
        let
          hostFileName = (removeSuffix ".nix" hostFile);
          hostPath = (path + "./hostFileName");
        in (nameValuePair hostFileName {
          modules = [ hostPath ../modules/os.nix ../secrets ];
          specialArgs = ({ lib = lib // { inherit (self) os; }; });
        }) (attrNames (readDir path)))));
  })

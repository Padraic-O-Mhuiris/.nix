(self: super:
  with builtins;
  let lib = self;
  in with lib; {
    os = import ./options.nix { inherit lib; };

    mkHosts = path:
      (listToAttrs (map (hostFile:
        nameValuePair (removeSuffix ".nix" hostFile) {
          modules = [ (path + "/${hostFile}") ../modules/os.nix ../secrets ];
          specialArgs = ({ lib = lib // { inherit (self) os; }; });
        }) (attrNames (readDir path))));
  })

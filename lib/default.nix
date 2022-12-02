{ lib, pkgs }:
lib.makeExtensible (_self: {
  host = host:
    (import ./hosts.nix {
      inherit lib pkgs;
      config = self.nixosConfigurations.${host}.config;
    });

  user = host': (_self.host host').users;

  # mkHost creates a single attrset for a fup "host". This is done so that
  # it's easier to create a custom lib which in it's scope can reference at
  # build time the specific host configuration
  mkHost = { name, modules }: {
    "${name}" = {
      inherit modules;
      specialArgs = {
        lib = ({
          host = (_self.host name);
          user = (_self.user name);
        } // lib);
      };
    };
  };
})

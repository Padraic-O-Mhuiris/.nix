{ config, options, lib, hm, ... }:

with lib;
with lib.my;

let inherit (lib) fileContents mkForce;
in {
  options = with types; {
    user = mkOpt attrs { };

    dotfiles = let t = either str path;
    in {
      dir = mkOpt t (findFirst pathExists (toString ../.) [
        "${config.user.home}/.nix"
        "${config.user.home}/.config/dotfiles"
        "/etc/dotfiles"
      ]);
      binDir = mkOpt t "${config.dotfiles.dir}/bin";
      configDir = mkOpt t "${config.dotfiles.dir}/config";
      modulesDir = mkOpt t "${config.dotfiles.dir}/modules";
      themesDir = mkOpt t "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = mkOpt' attrs { } "Files to place directly in $HOME";
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then
          concatMapStringsSep ":" (x: toString x) v
        else
          (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {

    user = let
      user = builtins.getEnv "USER";
      name = if elem user [ "" "root" ] then "padraic" else user;
    in {
      inherit name;
      description = "The primary user account";
      extraGroups = [
        "wheel" # sudo
        "plugdev" # ledger
        # TODO Networkmanager
      ];
      isNormalUser = true;
      home = "/home/${name}";
      group = "users";
      uid = 1000;
      hashedPassword =
        "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
    };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.hlissner.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.hlissner.home.file
      #   home.configFile  ->  home-manager.users.hlissner.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.hlissner.home.xdg.dataFile
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;

          # Suppresses version mismatch warning between home-manager and nixos
          # hm is used minimally in the system so should not be a major issue
          enableNixpkgsReleaseCheck = false;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;
    users.mutableUsers = false;

    programs.nix-ld.enable = true;

    nix = let users = [ config.user.name ];
    in {
      trustedUsers = users;
      allowedUsers = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}

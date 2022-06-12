{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my; {
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
  in {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    nixPath = nixPathInputs ++ [
      "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
      "dotfiles=${config.dotfiles.dir}"
    ];
    binaryCaches = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://dapp.cachix.org"
      "https://hydra.iohk.io"
      "https://iohk.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "dapp.cachix.org-1:9GJt9Ja8IQwR7YW/aF0QvCa6OmjGmsKoZIist0dG+Rs="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    ];
    registry = registryInputs // { dotfiles.flake = inputs.self; };
    autoOptimiseStore = true;
  };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.11";

  ## Some reasonable, global defaults
  # This is here to appease 'nix flake check' for generic hosts with no
  # hardware-configuration.nix or fileSystem config.
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

  # Use the latest kernel
  # boot = {
  #   kernelPackages = mkDefault pkgs.linuxPackages_5_10;
  #   loader = {
  #     efi.canTouchEfiVariables = mkDefault true;
  #     systemd-boot.configurationLimit = 10;
  #     systemd-boot.enable = mkDefault true;
  #   };
  # };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    coreutils
    git
    vim
    wget
    gnumake
    unzip
    iw
    nix-index
    patchelf
    stdenv.cc.cc.lib
    file
    libsecret
    zlib
  ];
}

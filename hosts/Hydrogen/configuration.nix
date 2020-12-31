# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

let
  inherit (lib) fileContents;

  passwordRoot = lib.mkForce (fileContents ../../secrets/root);
  passwordPadraic = lib.mkForce (fileContents ../../secrets/padraic);
in {
 
  nix = {
    buildCores = 4;
    binaryCaches = [ "https://cache.nixos.org" "https://dapp.cachix.org" ];
    binaryCachePublicKeys = [ "dapp.cachix.org-1:9GJt9Ja8IQwR7YW/aF0QvCa6OmjGmsKoZIist0dG+Rs=" ];
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes ca-references recursive-nix";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  imports = [
    ./hardware-configuration.nix
    ./thinkpadX1Carbon.nix
    ./fonts.nix
    ./boot.nix
  ];

  powerManagement.enable = true;

  networking.hostName = "Hydrogen"; # Define your hostname.
  networking.networkmanager = { enable = true; };

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Select internationalisation properties.
  time.timeZone = "Europe/Dublin";
  i18n = { defaultLocale = "en_IE.UTF-8"; };
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  # Enable sound.

  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    SHELL = "zsh";
  };

  programs.nm-applet = { enable = true; };

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = passwordRoot;
        hashedPassword = passwordRoot;
      };
      padraic = {
        uid = 1000;
        isNormalUser = true;
        group = "users";
        hashedPassword = passwordPadraic;
        extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
      };
    };
  };
 
  #home-manager.useUserPackages = true;
  #home-manager.users.padraic = {
  #  imports = [ ./home ];
  #  home.stateVersion = "20.09";
  #};

  environment.systemPackages = with pkgs; [
    bitwarden
    coreutils
    nixfmt
    wget
    vim
    htop
    git
    git-crypt
    acpi
    ripgrep
    xclip
    coreutils
    fd
    clang
    usbutils
    powertop
    xorg.libxcb
    bc
    cachix
    i7z
    glxinfo
    xdotool
    ### Pass
    #passExtensions.pass-audit
    #passExtensions.pass-genphrase
    #passExtensions.pass-import
    #passExtensions.pass-otp
    #passExtensions.pass-tomb
    #passExtensions.pass-update
    #(pass.withExtensions (ext:
    #  with ext; [
    #    pass-audit
    #    pass-otp
    #    pass-import
    #    pass-genphrase
    #    pass-update
    #    pass-tomb
    #  ]))
    #tomb
    ###
    lm_sensors
    dmidecode
    mtools
    xorg.xbacklight
    wordnet
    sqlite

    #niv
    #lorri
    #direnv
  ];

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 224 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -U 5";
      }
      {
        keys = [ 225 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -A 5";
      }
    ];
  };

  environment = {
    etc = {
      "sysconfig/lm_sensors".text = ''
        HWMON_MODULES="coretemp"
      '';
      "modprobe.d/usbhid.conf".text = ''
        options usbhid mousepoll=4
      '';
    };
  };

  services.localtime.enable = true;
  location.provider = "geoclue2";

  services.xserver = {
    enable = true;
    dpi = 180;
    videoDrivers = [ "modesetting" ];
    useGlamor = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "padraic";
      };
    };

    layout = "gb";
    xkbOptions = "ctrl:swapcaps";

    libinput = { enable = true; };
    desktopManager = {
      xterm.enable = false;
      session = [{
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.xsession &
          waitPID=$!
        '';
      }];
    };
  };
}

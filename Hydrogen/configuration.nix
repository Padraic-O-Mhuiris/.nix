# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  inherit (lib) fileContents;

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };

  
in {
  nix.buildCores = 4;
  #nix.binaryCaches = [ "https://cache.nixos.org" "https://dapp.cachix.org" ];
  #nix.binaryCachePublicKeys =
  #  [ "dapp.cachix.org-1:9GJt9Ja8IQwR7YW/aF0QvCa6OmjGmsKoZIist0dG+Rs=" ];

  # nix.nixPath = [''
  #   /home/padraic/.nix-defexpr/channels:"nixpkgs=${
  #     <nixpkgs>
  #   }":nixos-config=/home/padraic/.nix/Hydrogen/configuration.nix
  #    ''];

  # nix.extraOptions = ''
  #   plugin-files = ${
  #     pkgs.nix-plugins_4.override { nix = config.nix.package; }
  #   }/lib/nix/plugins/libnix-extra-builtins.so
  # '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  imports = [
    (import "${home-manager}/nixos")
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

  #users.users.root.hashedPassword = fileContents ./secrets/root;

  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    group = "users";
    #hashedPassword = fileContents ./secrets/padraic;
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

  home-manager.users.padraic = (import ./home);

  environment.systemPackages = with pkgs; [
    bitwarden
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

  system.stateVersion = "20.09"; # Did you read the comment?
}

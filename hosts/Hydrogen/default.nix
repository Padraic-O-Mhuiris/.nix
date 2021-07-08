# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  nix = {
    buildCores = 4;
    #   package = pkgs.nixFlakes;
    #   extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
    #     "experimental-features = nix-command flakes ca-references recursive-nix";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  imports = [
    ./hardware-configuration.nix
    ./thinkpadX1Carbon.nix
    ./fonts.nix
    ./boot.nix
    ../../cachix
    ../../users
    # ../../users/root
    # ../../users/padraic

    #../../profiles/emacs
    ../../profiles/gpg
    ../../profiles/pass
    ../../profiles/docker
    ../../profiles/git
    ../../profiles/hledger
    ../../profiles/projects
    ../../profiles/browser

    ../../languages/javascript
    ../../languages/python
    ##../../profiles/dapptools

    ../../profiles/telegram
  ];

  modules = {
    desktop = {
      i3.enable = true;
      term = {
        default = "xst";
        st.enable = true;
      };
    };
    editors = {
      default = "nvim";
      vim.enable = true;
      emacs.enable = true;
    };
    shell = {
      #gnupg.enable = true;
      zsh.enable = true;
    };
  };

  #sops.defaultSopsFile = ../../secrets.yaml;
  #sops.gnupgHome = "/home/padraic/.gnupg";
  #sops.sshKeyPaths = [];

  #sops.secrets.hello = {};

  # sops.secrets.hello.mode = "0440";
  # sops.secrets.hello.owner = config.users.users.padraic.name;

  powerManagement.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };
  networking = {
    hostName = "Hydrogen";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    hosts = { "192.168.0.55" = [ "Nitrogen" ]; };
  };
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
  hardware.ledger.enable = true;
  programs.nm-applet = { enable = true; };

  environment.systemPackages = with pkgs; [
    bitwarden
    coreutils
    deluge
    vlc
    binutils
    gnumake
    nixfmt
    flameshot
    gcc
    wget
    vim
    htop
    git
    git-crypt
    acpi
    xclip
    clang
    usbutils
    powertop
    xorg.libxcb
    bc
    cachix
    i7z
    unzip
    tree
    openssl
    libusb
    libcgroup
    libudev0-shim
    postgresql
    glxinfo
    xdotool
    clang
    lm_sensors
    dmidecode
    mtools
    xorg.xbacklight
    wordnet
    sqlite
    xdg-utils
    signal-desktop
    nodePackages.bash-language-server
    nodePackages.bitwarden-cli
    cargo
    graphviz
    jq
    iw
    clojure
    babashka
    josm
    #niv
    #lorri
    #direnv
    shc
    solc
    pandoc
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

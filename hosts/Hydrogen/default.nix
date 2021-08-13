# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  nix = { buildCores = 4; };

  imports = [ ./hardware-configuration.nix ../home.nix ];

  modules = {
    desktop = {
      hledger.enable = true;
      i3.enable = true;
      xmonad.enable = false;
      redshift.enable = true;
      fileManager.enable = true;
      telegram.enable = true;
      term = {
        default = "st";
        st.enable = true;
      };
      tools = {
        libreoffice.enable = true;
        dapptools.enable = true;
      };
      media = { spotify.enable = true; };
      browser = {
        default = "brave";
        firefox.enable = true;
        brave.enable = true;
      };
    };
    editors = {
      default = "nvim";
      vim.enable = true;
      emacs.enable = true;
      languages = {
        javascript.enable = true;
        python.enable = true;
      };
    };
    shell = {
      gnupg.enable = true;
      zsh.enable = true;
      git.enable = true;
      pass.enable = true;
    };
    services = { docker.enable = true; };
  };

  #sops.defaultSopsFile = ../../secrets.yaml;
  #sops.gnupgHome = "/home/padraic/.gnupg";
  #sops.sshKeyPaths = [];

  #sops.secrets.hello = {};

  # sops.secrets.hello.mode = "0440";
  # sops.secrets.hello.owner = config.users.users.padraic.name;

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

  programs.nm-applet = { enable = true; };

  environment.systemPackages = with pkgs; [
    bitwarden
    bluez

    libical
    libudev0-shim

    coreutils
    deluge
    vlc
    binutils
    gnumake
    nixfmt
    flameshot
    gcc
    vim
    htop
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
    josm
    shc
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

  # environment = {
  #   etc = {
  #     "sysconfig/lm_sensors".text = ''
  #       HWMON_MODULES="coretemp"
  #     '';
  #     "modprobe.d/usbhid.conf".text = ''
  #       options usbhid mousepoll=4
  #     '';
  #   };
  # };

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

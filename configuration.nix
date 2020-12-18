# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  dapptools = import (builtins.fetchTarball {
    url = "https://github.com/dapphub/dapptools/tarball/master";
  }) { };

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };
in {

  imports = [
    (import "${home-manager}/nixos")
    <nixos-hardware/lenovo/thinkpad/x1/7th-gen>
    ./hardware-configuration.nix
    ./fonts.nix
  ];

  nix.buildCores = 4;
  nix.binaryCaches = [ "https://cache.nixos.org" "https://dapp.cachix.org" ];
  nix.binaryCachePublicKeys =
    [ "dapp.cachix.org-1:9GJt9Ja8IQwR7YW/aF0QvCa6OmjGmsKoZIist0dG+Rs=" ];

  nixpkgs.config.allowUnfree = true;

  hardware.opengl.driSupport32Bit = true; # steam

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };

  boot.initrd.luks.devices = {
    enc-pv = {
      device = "/dev/disk/by-uuid/591397ac-e675-47e3-acc1-ee3a6c3ceeb0";
      preLVM = true;
    };
  };

  powerManagement.enable = true;

  networking.hostName = "Hydrogen"; # Define your hostname.
  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;

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
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    SHELL = "zsh";
  };

  programs.nm-applet = { enable = true; };

  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    group = "users";
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

  home-manager.users.padraic = (import "/home/padraic/.nix/home.nix");

  environment.systemPackages = with pkgs; [
    nixfmt
    wget
    vim
    htop
    git
    acpi
    ripgrep
    xclip
    lsof
    coreutils
    fd
    clang
    usbutils
    powertop
    xorg.xdpyinfo
    xorg.libxcb
    bc
    cachix
    hwinfo
    i7z
    glxinfo
    xdotool
    ### Pass
    passExtensions.pass-audit
    passExtensions.pass-genphrase
    passExtensions.pass-import
    passExtensions.pass-otp
    passExtensions.pass-tomb
    passExtensions.pass-update
    (pass.withExtensions (ext:
      with ext; [
        pass-audit
        pass-otp
        pass-import
        pass-genphrase
        pass-update
        pass-tomb
      ]))
    tomb
    ###
    lm_sensors
    dmidecode
    pavucontrol
    mtools
    xorg.xbacklight
  ];

  hardware.video.hidpi.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  services.thermald.enable = true;

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
  services.blueman.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
      USB_BLACKLIST = "046d:c539";
      USB_BLACKLIST_BTUSB = 1;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
    };
  };

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

  systemd.services = {
    tune-usb-autosuspend = {
      description = "Disable USB autosuspend";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Type = "oneshot"; };
      unitConfig.RequiresMountsFor = "/sys";
      script = ''
        echo -1 > /sys/module/usbcore/parameters/autosuspend
      '';
    };
  };
  system.stateVersion = "20.09"; # Did you read the comment?
}

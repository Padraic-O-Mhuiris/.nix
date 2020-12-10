# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };
in {
  imports =
    [
      (import "${home-manager}/nixos")
      <nixos-hardware/lenovo/thinkpad/x1/7th-gen>
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
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

  networking.hostName = "Hydrogen"; # Define your hostname.
  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;


  # Select internationalisation properties.
  time.timeZone = "Europe/Dublin";
  i18n = {
    defaultLocale = "en_IE.UTF-8";
  };
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
    XCURSOR_SIZE = "64";
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    SHELL = "zsh";
  };

  programs.nm-applet = {
    enable = true;
  };

  users.users.padraic = {
    uid = 1000;
    isNormalUser = true;
    group = "users";
    extraGroups = [ "wheel" "audio" "networkmanager" "video" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;

    pinentryFlavor = "curses";
  };

  home-manager.useUserPackages = true;
  home-manager.users.padraic = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    programs.google-chrome.enable = true;

    home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
    home.file.".config/udiskie/config.yml".text = ''
      device_config:
        - device_file: /dev/loop0
          ignore: true
    '';
    programs.git = {
      enable = true;
      userName = "Padraic-O-Mhuiris";
      userEmail = "patrick.morris.310@gmail.com";
      signing = {
        key = "0xBD01159F2C44F16B";
        signByDefault = true;
      };
      extraConfig = {
        http = {
          postBuffer = "524288000";
        };
      };
    };
    programs.gpg.enable = true;
    services.udiskie = {
      enable = true;
      notify = false;
    };

    home.sessionVariables = {
      PASSWORD_STORE_DIR = "$HOME/.secrets";
      PASSWORD_STORE_TOMB_FILE = "$HOME/.secrets/graveyard.tomb";
      PASSWORD_STORE_TOMB_KEY = "/run/media/padraic/Backup/shovel.tomb";
    }; 
    programs.zsh = {
      enable = true;
   };
  };
 
  environment.systemPackages = with pkgs; [
    wget 
    vim
    htop
    emacs
    git
    ripgrep
    rxvt_unicode
    xclip
    lsof
    coreutils
    fd
    clang
    ### Pass
    passExtensions.pass-audit
    passExtensions.pass-genphrase
    passExtensions.pass-import
    passExtensions.pass-otp
    passExtensions.pass-tomb
    passExtensions.pass-update
    (pass.withExtensions (ext: with ext; [ pass-audit pass-otp pass-import pass-genphrase pass-update pass-tomb]))
    tomb
    ### 
    gnupg
    lm_sensors
    dmidecode
    pavucontrol
    mtools
    xorg.xbacklight
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  services.thermald.enable=true;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
    ];
  };
  
  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';
  powerManagement.powertop.enable = true;

  services.localtime.enable = true;
  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
  services.blueman.enable = true;
  services.tlp = {
    enable = true;
  };
  services.xserver = {
    enable = true;
    dpi= 180;

    layout = "gb";
    xkbOptions = "ctrl:swapcaps";

    libinput.enable = true;
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        i3-gaps
      ];
    };
  };

  system.stateVersion = "20.09"; # Did you read the comment?
}


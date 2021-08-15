{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    efiSupport = true;
    device = "nodev";
    fontSize = 30;
    gfxmodeEfi = "1280x800";
    gfxmodeBios = "1280x800";
  };

  boot.zfs.enableUnstable = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.devNodes = "/dev/disk/by-path";

  boot.initrd.supportedFilesystems = [ "zfs" ]; # boot from zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  networking.hostName = "Oxygen";

  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  time.timeZone = "Europe/Dublin";

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  environment.sessionVariables = { GNUPGHOME = "$HOME/.config/gnupg"; };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = "gnome3";
  };
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "*";
    users.padraic = {
      isNormalUser = true;
      createHome = true;
      home = "/home/padraic";
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPassword =
        "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
    };
  };

  services.xserver = {
    enable = true;
    dpi = 110;

    layout = "gb";
    libinput.enable = true;
    xkbOptions = "ctrl:swapcaps";

    displayManager = { defaultSession = "none+i3"; };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    unzip
    gitAndTools.gitFull
    pinentry-curses
    pinentry-qt
    paperkey
    yubikey-personalization
    yubikey-manager
  ];

  services.openssh.enable = true;
  system.stateVersion = "21.05"; # Did you read the comment?
}

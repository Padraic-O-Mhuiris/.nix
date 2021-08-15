# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Must pull in home-manager from channel to run first
    # nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager
    # nix-channel --update
    <home-manager/nixos>
  ];

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
  networking.hostId = "92c7e9d8";

  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  # Set your time zone.
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
    mutableUsers = true;
    users.padraic = {
      isNormalUser = true;
      home = "/home/padraic";
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "abc123";
    };
  };

  home-manager.users.padraic = {
    home.file.".config/gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl 3600
        pinentry-program ${pkgs.pinentry.gnome3}/bin/pinentry
        allow-emacs-pinentry
        allow-loopback-pinentry

        ## test comment
        # https://github.com/drduh/config/blob/master/gpg.conf
        # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
        # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
        # Use AES256, 192, or 128 as cipher
        personal-cipher-preferences AES256 AES192 AES
        # Use SHA512, 384, or 256 as digest
        personal-digest-preferences SHA512 SHA384 SHA256
        # Use ZLIB, BZIP2, ZIP, or no compression
        personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
        # Default preferences for new keys
        default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
        # SHA512 as digest to sign keys
        cert-digest-algo SHA512
        # SHA512 as digest for symmetric ops
        s2k-digest-algo SHA512
        # AES256 as cipher for symmetric ops
        s2k-cipher-algo AES256
        # UTF-8 support for compatibility
        charset utf-8
        # Show Unix timestamps
        fixed-list-mode
        # No comments in signature
        no-comments
        # No version in output
        no-emit-version
        # Disable banner
        no-greeting
        # Long hexidecimal key format
        keyid-format 0xlong
        # Display UID validity
        list-options show-uid-validity
        verify-options show-uid-validity
        # Display all keys and their fingerprints
        with-fingerprint
        # Display key origins and updates
        #with-key-origin
        # Cross-certify subkeys are present and valid
        require-cross-certification
        # Disable caching of passphrase for symmetrical ops
        no-symkey-cache
        # Enable smartcard
        use-agent
        # Disable recipient key ID in messages
        throw-keyids
        # Default/trusted key ID to use (helpful with throw-keyids)
        #default-key 0xFF3E7D88647EBCDB
        #trusted-key 0xFF3E7D88647EBCDB
        # Group recipient keys (preferred ID last)
        #group keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB
        # Keyserver URL
        #keyserver hkps://keys.openpgp.org
        #keyserver hkps://keyserver.ubuntu.com:443
        #keyserver hkps://hkps.pool.sks-keyservers.net
        #keyserver hkps://pgp.ocf.berkeley.edu
        # Proxy to use for keyservers
        #keyserver-options http-proxy=http://127.0.0.1:8118
        #keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050
        # Verbose output
        #verbose
        # Show expired subkeys
        #list-options show-unusable-subkeys
      '';

      home.file."config/git/config".text = ''
        [user]
        	name = Pádraic Ó Mhuiris
        	email = patrick.morris.310@gmail.com
        	signingKey = 9A51DBF629888EE75982008D9DCE7055406806F8
        [core]
        	whitespace = trailing-space
        [init]
        	defaultBranch = main
        [github]
        	user = Padraic-O-Mhuiris
        [rebase]
        	autosquash = true
        [push]
        	default = current
        [pull]
        	rebase = true
        [commit]
        	gpgSign = true
        [http]
            postBuffer = '' 524288000 "\n";

      home.file.".ssh/id_rsa.pub".text =
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgUhCu8wM3/3cVmYNhhB6tkSiMHuD5PAcundraTGb7dSesP8XbC9kKttncXGAJcKwgGeXBpsRO2OHNtksJFtUkxB5NAAsMZthxe/k1xen58rw6R4qjTqg+JrSF3X5gZJNLszE1yItgFJCYfMMNXQIQLRclbBlXYAKC32w018xMQpFw2ecvlqTwg37N7rrMxFKHi4CASbnySsrMnYQW9JrOrX3cSHQXuOB47CsKPuOhLnJ//cE+aWgEF4hLLAqnSiqLuqKQQwBxywxHGRQPaFtPNydbmmMcuJKxcNSKqKePFXw+CpZDvRGOssiDOn2hkBl66qj0ED0C4mOYNspZxA/wahiSqhkUEKK4CtuNgjV39m+q9L/z/I5m1CSRrXXPFlG5ukCbvzD5jovvEuNa4UrVl0TLUZVUaErXcXl5innSv05Y9mXhzM1myba0L4UJKCRgCxFW48FnfteLWI6+4t+yl0rXvlhzyuXCY9XS1WrmL7kBtnErEPTRBeaPLsh7fMKm5wwrfBHWYg/WTR7TLdcD/zAcHiaZPRpmFa3RIBJWHjHe9sZkWMfFxrNQLYg9y/MoSjYEqZBWzO+J9I3SkT9T1VIX3ynolasWPuzXc9ntXjxtMBslyN50SSkNR28TO+pob2KSyf+6F7d2XA37pOuvdqdoAdHBBnbZ277s/rOIAw== openpgp:0xAF0D2F25";
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
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

  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

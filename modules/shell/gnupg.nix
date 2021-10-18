{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable = mkBoolOpt false;
    cacheTTL = mkOpt int 3600; # 1hr
    gpgPublicKey = mkOpt str "9A51DBF629888EE75982008D9DCE7055406806F8";
  };

  config = mkIf cfg.enable {
    env.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    env.GPG_KEY = cfg.gpgPublicKey;

    programs.gnupg.agent = {
      enable = true;
      #enableSSHSupport = config.modules.shell.ssh.enable;
      enableExtraSocket = true;
      pinentryFlavor = "gtk2";
    };

    user.packages = with pkgs; [
      pinentry
      pinentry-gnome
      paperkey
      yubikey-personalization
      yubikey-manager
    ];
    services.pcscd.enable = true;
    services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      programs.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    home.configFile."gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
        allow-emacs-pinentry
        allow-loopback-pinentry

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
    };
  };
}

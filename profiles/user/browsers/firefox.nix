{ config, lib, pkgs, ... }:

let
  bookmarkUrls = lib.forEach [
    "https://mail.google.com/mail/u/0/?hl=en#inbox"
    "https://www.youtube.com/"
    "https://twitter.com/home"
    "https://www.instagram.com/"
    "https://web.whatsapp.com/"
    "https://github.com/"
    "https://old.reddit.com/"
    "https://chat.openai.com/"
    "https://www.twitch.tv/"
    "https://www.netflix.com/browse"
    "https://news.ycombinator.com/news"
    "https://www.daft.ie/property-for-sale/galway-city"
    "https://lobste.rs/"
    "https://www.coingecko.com/en"
    "https://www.chess.com/play"
    "https://beaconcha.in/dashboard?validators=79330,79331,79332,79333"

  ] (url: {
    inherit url;
    name = "";
  });

  firefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      BlockAboutAddons = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;
      Bookmarks = [ ]; # Another bookmarks strategy
      CaptivePortal = false;
      DefaultDownloadDirectory = "$HOME/Downloads";
      DisableAppUpdate = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = false;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      HardwareAcceleration = true;
      InstallAddonsPermission = { Default = true; };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        CryptoMining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponseredPocked = false;
        Snippets = false;
        Locked = true;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      Homepage = {
        Locked = true;
        StartPage = "none";
      };
    };
  };

in {
  os.user.hm.programs.firefox = {
    enable = true;
    package = firefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      metamask
      bitwarden
      old-reddit-redirect
      i-dont-care-about-cookies
    ];
    profiles = {
      main = {
        id = 0;
        search = {
          default = "DuckDuckGo";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
          };
        };
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.shell.checkDefaultBrowser" = false;
        };
        bookmarks = [{
          name = "Toolbar Bookmarks";
          toolbar = true;
          bookmarks = bookmarkUrls;
        }];
        userChrome = "";
        userContent = "";
      };
    };
  };
}

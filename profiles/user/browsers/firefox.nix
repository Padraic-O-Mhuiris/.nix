{ config, lib, pkgs, ... }:

{
  os.user.hm.programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        AppAutoUpdate = false;
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        DisableProfileImport = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = false;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
    profiles = {
      main = {
        id = 0;
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.places.importBookmarksHTML" = true;
          "browser.toolbars.bookmarks.showOtherBookmarks" = true;
        };
        bookmarks = [{
          name = "wikipedia";
          keyword = "wikiaaaaaa";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
        }];
      };
    };
  };
}
